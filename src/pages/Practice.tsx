import { CodeIcon } from '../components/icons'

export function Practice() {
  return (
    <div className="page-frame flex min-h-[60svh] flex-col items-center justify-center text-center">
      <span className="forge-icon-tile h-14 w-14"><CodeIcon className="text-accent" size={29} /></span>
      <p className="page-kicker mt-5">In the workshop</p><h1 className="font-heading text-3xl text-text">Practice playground</h1>
      <p className="max-w-xs text-text-secondary">
        A freeform sandbox to experiment outside of lessons is coming in a later update.
      </p>
    </div>
  )
}
