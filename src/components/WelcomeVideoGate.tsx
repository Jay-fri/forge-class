import { useState, type ReactNode } from 'react'
import { useAuth } from '../contexts/AuthContext'
import { supabase } from '../lib/supabase'
import { BookIcon, ForgeMark } from '../components/icons'

/**
 * Shown once, right after approval, before any lesson content — a short
 * walkthrough video. Skippable so a missing/not-yet-recorded video never
 * blocks access; drop the real file at /public/welcome-video.mp4 and it
 * plays automatically, no code changes needed.
 */
export function WelcomeVideoGate({ children }: { children: ReactNode }) {
  const { profile, refreshProfile } = useAuth()
  const [videoMissing, setVideoMissing] = useState(false)
  const [dismissing, setDismissing] = useState(false)

  if (!profile || profile.welcome_video_watched_at) return <>{children}</>

  async function dismiss() {
    if (!profile) return
    setDismissing(true)
    await supabase
      .from('profiles')
      .update({ welcome_video_watched_at: new Date().toISOString() })
      .eq('id', profile.id)
    await refreshProfile()
    setDismissing(false)
  }

  return (
    <div className="forge-auth flex min-h-svh flex-col items-center justify-center gap-6 bg-background px-5 py-8 text-center sm:px-8">
      <div className="forge-card w-full max-w-2xl p-5 sm:p-8"><span className="forge-icon-tile h-12 w-12"><ForgeMark className="text-accent" size={26} /></span>
      <div>
        <p className="page-kicker mt-4">Your first two minutes</p><h1 className="mt-1 font-heading text-4xl text-text">Welcome to Forge</h1>
        <p className="mt-2 text-text-secondary">
          A quick look at how everything works, before you dive in.
        </p>
      </div>

      <div className="mt-6 w-full overflow-hidden rounded-2xl border border-border bg-surface text-left">
        {videoMissing ? (
          <div className="flex aspect-video flex-col items-center justify-center gap-3 px-6 text-sm text-text-secondary">
            <BookIcon className="text-accent" size={26} />Walkthrough video coming soon.
          </div>
        ) : (
          <video
            className="aspect-video w-full"
            src="/welcome-video.mp4"
            controls
            onError={() => setVideoMissing(true)}
          />
        )}
      </div>

      <button
        type="button"
        onClick={dismiss}
        disabled={dismissing}
        className="forge-button mt-6 disabled:opacity-60"
      >
        {videoMissing ? 'Continue' : 'Skip for now'}
      </button></div>
    </div>
  )
}
