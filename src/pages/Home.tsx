import { useAuth } from '../contexts/AuthContext'
import { FlameIcon } from '../components/icons'

export function Home() {
  const { profile, signOut } = useAuth()

  return (
    <div className="mx-auto max-w-lg px-6 py-10">
      <h1 className="font-heading text-2xl text-text">
        Welcome, {profile?.full_name?.split(' ')[0] ?? 'there'}
      </h1>
      <p className="mt-2 text-text-secondary">
        This is a placeholder home screen — Phase 0 only covers the routing
        shell and auth. "Continue learning", streaks, and the real home feed
        arrive in Phase 3–4.
      </p>

      <div className="mt-6 flex items-center gap-2 rounded-xl border border-border bg-surface px-4 py-3 text-sm text-text-secondary">
        <FlameIcon className="text-accent" size={20} />
        Streak tracking coming in Phase 4.
      </div>

      <button
        type="button"
        onClick={() => signOut()}
        className="mt-8 text-sm text-text-secondary hover:text-text hover:underline"
      >
        Log out
      </button>
    </div>
  )
}
