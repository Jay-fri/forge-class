import { TrendingIcon } from '../components/icons'

export function Progress() {
  return (
    <div className="flex flex-col items-center gap-3 px-6 py-16 text-center">
      <TrendingIcon className="text-accent" size={32} />
      <h1 className="font-heading text-xl text-text">Progress</h1>
      <p className="max-w-xs text-text-secondary">
        Streaks, badges, and certificates land in the next phase.
      </p>
    </div>
  )
}
