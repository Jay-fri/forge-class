import { CodeIcon } from '../components/icons'

export function Practice() {
  return (
    <div className="flex flex-col items-center gap-3 px-6 py-16 text-center">
      <CodeIcon className="text-accent" size={32} />
      <h1 className="font-heading text-xl text-text">Practice playground</h1>
      <p className="max-w-xs text-text-secondary">
        A freeform sandbox to experiment outside of lessons is coming in a later update.
      </p>
    </div>
  )
}
