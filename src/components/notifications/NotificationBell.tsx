import { useEffect, useRef, useState } from 'react'
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
  const containerRef = useRef<HTMLDivElement>(null)

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
      if (containerRef.current && !containerRef.current.contains(e.target as Node)) setOpen(false)
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

  return (
    <div ref={containerRef} className="relative">
      <button
        type="button"
        onClick={() => setOpen((o) => !o)}
        aria-label="Notifications"
        className="relative text-text-secondary hover:text-text"
      >
        <BellIcon size={20} />
        {unreadCount > 0 && (
          <span className="absolute -right-1 -top-1 flex h-4 min-w-4 items-center justify-center rounded-full bg-accent px-1 text-[10px] font-medium text-background">
            {unreadCount > 9 ? '9+' : unreadCount}
          </span>
        )}
      </button>

      <AnimatePresence>
        {open && (
          <motion.div
            initial={{ opacity: 0, scale: 0.96, y: -4 }}
            animate={{ opacity: 1, scale: 1, y: 0 }}
            exit={{ opacity: 0, scale: 0.96, y: -4 }}
            transition={{ duration: 0.15 }}
            className="fixed inset-x-4 top-16 z-50 max-h-[70svh] overflow-y-auto rounded-xl border border-border bg-surface shadow-xl lg:absolute lg:inset-x-auto lg:top-full lg:left-0 lg:right-auto lg:mt-2 lg:w-80 lg:max-w-[calc(100vw-2rem)]"
          >
            <div className="flex items-center justify-between border-b border-border px-4 py-3">
              <p className="font-heading text-text">Notifications</p>
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
                    className={`flex items-start gap-3 border-b border-border/60 px-4 py-3 last:border-b-0 transition-colors hover:bg-background/40 ${
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
      </AnimatePresence>
    </div>
  )
}
