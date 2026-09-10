import { useState, type ReactNode } from 'react'
import { useAuth } from '../contexts/AuthContext'
import { supabase } from '../lib/supabase'
import { ForgeMark } from '../components/icons'

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
    <div className="flex min-h-svh flex-col items-center justify-center gap-6 bg-background px-6 text-center">
      <ForgeMark className="text-accent" size={32} />
      <div>
        <h1 className="font-heading text-2xl text-text">Welcome to Forge</h1>
        <p className="mt-2 text-text-secondary">
          A quick look at how everything works, before you dive in.
        </p>
      </div>

      <div className="w-full max-w-lg overflow-hidden rounded-xl border border-border bg-surface">
        {videoMissing ? (
          <div className="flex aspect-video items-center justify-center px-6 text-sm text-text-secondary">
            Walkthrough video coming soon.
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
        className="rounded-lg bg-accent px-5 py-2.5 font-medium text-background hover:opacity-90 disabled:opacity-60"
      >
        {videoMissing ? 'Continue' : 'Skip for now'}
      </button>
    </div>
  )
}
