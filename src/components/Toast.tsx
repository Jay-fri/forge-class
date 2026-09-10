import { AnimatePresence, motion } from 'framer-motion'
import { TrophyIcon } from './icons'

/**
 * Slides from top, auto-dismisses, non-blocking — for streak milestones,
 * badge awards, and minor confirmations. Never use this for anything that
 * needs a decision; that's a blocking modal instead (see brand nav spec).
 */
export function Toast({ message }: { message: string | null }) {
  return (
    <div className="pointer-events-none fixed inset-x-0 top-0 z-40 flex justify-center px-4 pt-4">
      <AnimatePresence>
        {message && (
          <motion.div
            initial={{ y: -40, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            exit={{ y: -40, opacity: 0 }}
            transition={{ type: 'spring', damping: 24, stiffness: 300 }}
            className="pointer-events-auto flex items-center gap-2 rounded-full border border-accent/30 bg-surface px-4 py-2.5 text-sm text-text shadow-lg"
          >
            <TrophyIcon className="text-accent" size={18} />
            {message}
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  )
}
