import { useEffect, useState } from 'react'
import { AnimatePresence, motion } from 'framer-motion'
import { ForgeMark, XIcon } from './icons'

const DISMISS_KEY = 'forge-install-dismissed'

interface BeforeInstallPromptEvent extends Event {
  prompt: () => Promise<void>
  userChoice: Promise<{ outcome: 'accepted' | 'dismissed' }>
}

function isStandalone(): boolean {
  return (
    window.matchMedia('(display-mode: standalone)').matches ||
    (navigator as unknown as { standalone?: boolean }).standalone === true
  )
}

function isIOS(): boolean {
  return /iphone|ipad|ipod/i.test(navigator.userAgent)
}

export function InstallPrompt() {
  const [deferredEvent, setDeferredEvent] = useState<BeforeInstallPromptEvent | null>(null)
  const [showIosHint, setShowIosHint] = useState(false)
  const [dismissed, setDismissed] = useState(() => localStorage.getItem(DISMISS_KEY) === '1')

  useEffect(() => {
    if (isStandalone() || dismissed) return

    function handler(e: Event) {
      e.preventDefault()
      setDeferredEvent(e as BeforeInstallPromptEvent)
    }
    window.addEventListener('beforeinstallprompt', handler)

    // iOS Safari never fires beforeinstallprompt, so there's no native
    // prompt to defer — show a manual hint instead, after a short delay so
    // it doesn't compete with first-load content.
    let timer: ReturnType<typeof setTimeout> | undefined
    if (isIOS()) {
      timer = setTimeout(() => setShowIosHint(true), 4000)
    }

    return () => {
      window.removeEventListener('beforeinstallprompt', handler)
      if (timer) clearTimeout(timer)
    }
  }, [dismissed])

  function dismiss() {
    localStorage.setItem(DISMISS_KEY, '1')
    setDismissed(true)
    setDeferredEvent(null)
    setShowIosHint(false)
  }

  async function install() {
    if (!deferredEvent) return
    await deferredEvent.prompt()
    await deferredEvent.userChoice
    dismiss()
  }

  const visible = !dismissed && (deferredEvent !== null || showIosHint)

  return (
    <AnimatePresence>
      {visible && (
        <motion.div
          initial={{ y: 40, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          exit={{ y: 40, opacity: 0 }}
          transition={{ type: 'spring', damping: 26, stiffness: 300 }}
          className="fixed inset-x-4 bottom-20 z-40 flex items-center gap-3 rounded-xl border border-border bg-surface px-4 py-3 shadow-xl lg:inset-x-auto lg:bottom-6 lg:left-6 lg:max-w-sm"
        >
          <ForgeMark className="shrink-0 text-accent" size={24} />
          <div className="min-w-0 flex-1">
            <p className="text-sm font-medium text-text">Install Forge</p>
            <p className="text-xs text-text-secondary">
              {deferredEvent
                ? 'Add it to your home screen for quick, full-screen access.'
                : 'Tap the Share icon, then "Add to Home Screen".'}
            </p>
          </div>
          {deferredEvent && (
            <button
              type="button"
              onClick={install}
              className="shrink-0 rounded-lg bg-accent px-3 py-1.5 text-sm font-medium text-background hover:opacity-90"
            >
              Install
            </button>
          )}
          <button
            type="button"
            onClick={dismiss}
            aria-label="Dismiss"
            className="shrink-0 text-text-secondary hover:text-text"
          >
            <XIcon size={16} />
          </button>
        </motion.div>
      )}
    </AnimatePresence>
  )
}
