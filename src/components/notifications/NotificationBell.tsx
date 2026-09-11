import { useEffect, useRef, useState, type CSSProperties } from 'react'
import { createPortal } from 'react-dom'
import { Link } from 'react-router-dom'
import { AnimatePresence, motion } from 'framer-motion'
import { useAuth } from '../../contexts/AuthContext'
import {
  listNotifications,
  markNotificationsRead,
  subscribeToNotifications,
  timeAgo,
  type Notification,
} from '../../lib/notifications'
import { BellIcon, BookIcon, PencilIcon } from '../icons'

export function NotificationBell() {
  const { user } = useAuth()
  const [notifications, setNotifications] = useState<Notification[]>([])
  const [open, setOpen] = useState(false)
  const [panelStyle, setPanelStyle] = useState<CSSProperties>({})
  const containerRef = useRef<HTMLDivElement>(null)
  const buttonRef = useRef<HTMLButtonElement>(null)
  const panelRef = useRef<HTMLDivElement>(null)

  const unreadCount = notifications.filter((n) => !n.read_at).length

  useEffect(() => {
    listNotifications().then(setNotifications)
  }, [])

  useEffect(() => {
    if (!user) return
    return subscribeToNotifications(user.id, (n) => setNotifications((prev) => [n, ...prev]))
  }, [user])

  useEffect(() => {
    if (!open) return
    function handleClick(e: MouseEvent) {
      const target = e.target as Node
      const insideButton = containerRef.current?.contains(target)
      const insidePanel = panelRef.current?.contains(target)
      if (!insideButton && !insidePanel) setOpen(false)
    }
    document.addEventListener('mousedown', handleClick)
    return () => document.removeEventListener('mousedown', handleClick)
  }, [open])

  useEffect(() => {
    if (!open) return
    const unreadIds = notifications.filter((n) => !n.read_at).map((n) => n.id)
    if (unreadIds.length === 0) return
    const timer = setTimeout(() => {
      markNotificationsRead(unreadIds)
      setNotifications((prev) =>
        prev.map((n) => (unreadIds.includes(n.id) ? { ...n, read_at: new Date().toISOString() } : n)),
      )
    }, 1200)
    return () => clearTimeout(timer)
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open])

  // Positioned via a portal to document.body and computed coordinates rather
  // than CSS anchoring: the bell lives inside the sidebar, which needs its
  // own overflow-y-auto so it can scroll independently of the main content,
  // and any ancestor with overflow other than visible clips an absolutely
  // positioned dropdown instead of letting it float above the page.
  function toggleOpen() {
    if (!open && buttonRef.current) {
      const rect = buttonRef.current.getBoundingClientRect()
      const isDesktop = window.innerWidth >= 1024
      if (isDesktop) {
        const panelWidth = 384
        const left = Math.min(rect.left, window.innerWidth - panelWidth - 16)
        setPanelStyle({ position: 'fixed', top: rect.bottom + 8, left: Math.max(16, left), width: panelWidth })
      } else {
        setPanelStyle({ position: 'fixed', top: rect.bottom + 12, left: 12, right: 12 })
      }
    }
    setOpen((o) => !o)
  }

  return (
    <div ref={containerRef} className="relative">
      <button
        ref={buttonRef}
        type="button"
        onClick={toggleOpen}
        aria-label="Notifications"
        className="forge-icon-tile relative h-9 w-9 rounded-lg text-text-secondary hover:text-text"
      >
        <BellIcon size={20} />
        {unreadCount > 0 && (
          <span className="absolute -right-1 -top-1 flex h-4 min-w-4 items-center justify-center rounded-full bg-accent px-1 text-[10px] font-medium text-background">
            {unreadCount > 9 ? '9+' : unreadCount}
          </span>
        )}
      </button>

      {createPortal(
        <AnimatePresence>
          {open && (
            <motion.div
              ref={panelRef}
              style={panelStyle}
              initial={{ opacity: 0, scale: 0.96, y: -4 }}
              animate={{ opacity: 1, scale: 1, y: 0 }}
              exit={{ opacity: 0, scale: 0.96, y: -4 }}
              transition={{ duration: 0.15 }}
              className="z-50 max-h-[76svh] overflow-y-auto rounded-2xl border border-border bg-surface shadow-2xl shadow-black/40"
            >
              <div className="flex items-center justify-between border-b border-border px-4 py-3">
                <div><p className="font-heading text-xl text-text">Notifications</p><p className="forge-panel-label">Your recent activity</p></div>
              </div>
              {notifications.length === 0 ? (
                <p className="px-4 py-8 text-center text-sm text-text-secondary">
                  Nothing yet. New grades and lessons will show up here.
                </p>
              ) : (
                <div className="flex flex-col">
                  {notifications.map((n) => (
                    <Link
                      key={n.id}
                      to={n.link ?? '/home'}
                      onClick={() => setOpen(false)}
                      className={`flex items-start gap-3 border-b border-border/60 px-4 py-4 last:border-b-0 transition-colors hover:bg-background/40 ${
                        n.read_at ? '' : 'bg-accent/5'
                      }`}
                    >
                      <span className="mt-0.5 flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-accent/10 text-accent">
                        {n.type === 'submission_graded' ? <PencilIcon size={15} /> : <BookIcon size={15} />}
                      </span>
                      <div className="min-w-0">
                        <p className="text-sm font-medium text-text">{n.title}</p>
                        {n.body && <p className="mt-0.5 text-xs text-text-secondary">{n.body}</p>}
                        <p className="mt-1 text-xs text-text-secondary/70">{timeAgo(n.created_at)}</p>
                      </div>
                      {!n.read_at && <span className="ml-auto mt-1.5 h-2 w-2 shrink-0 rounded-full bg-accent" />}
                    </Link>
                  ))}
                </div>
              )}
            </motion.div>
          )}
        </AnimatePresence>,
        document.body,
      )}
    </div>
  )
}
