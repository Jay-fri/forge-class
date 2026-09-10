import { Link, Navigate } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'
import { useActiveBundles } from '../lib/bundles'
import { BookIcon, CodeIcon, ForgeMark, SparkleIcon } from '../components/icons'
import { IdeMockup } from '../components/marketing/IdeMockup'
import { BundleCard } from '../components/marketing/BundleCard'

export function Landing() {
  const { session, profile, loading } = useAuth()
  const { bundles, loading: bundlesLoading } = useActiveBundles()

  if (!loading && session && profile) {
    if (profile.role === 'instructor') return <Navigate to="/admin" replace />
    if (profile.approval_status === 'approved') return <Navigate to="/home" replace />
    return <Navigate to="/pending" replace />
  }

  return (
    <div className="forge-marketing min-h-svh overflow-hidden bg-background">
      <header className="mx-auto flex max-w-6xl items-center gap-2 px-5 py-5 sm:px-8">
        <span className="forge-icon-tile h-10 w-10"><ForgeMark className="text-accent" size={23} /></span>
        <div><span className="font-heading text-xl leading-none text-text">Forge</span><p className="font-mono text-[9px] uppercase tracking-[.16em] text-text-secondary">learn by making</p></div>
        <nav className="ml-auto flex items-center gap-3 text-sm">
          <Link to="/login" className="text-text-secondary hover:text-text">
            Log in
          </Link>
          <Link
            to="/signup"
            className="forge-button min-h-0 px-3.5 py-2 text-sm"
          >
            Get started
          </Link>
        </nav>
      </header>

      {/* Hero */}
      <section className="mx-auto grid max-w-6xl gap-10 px-5 pb-16 pt-10 sm:px-8 md:grid-cols-[.95fr_1.05fr] md:items-center md:pt-20 lg:gap-16 lg:pb-24">
        <div className="relative">
          <p className="page-kicker">A practical coding cohort</p>
          <h1 className="mt-3 font-heading text-5xl leading-[.94] text-text sm:text-6xl lg:text-7xl">
            Learn to code by actually{' '}
            <span className="text-accent">writing code</span>.
          </h1>
          <p className="mt-6 max-w-xl text-lg text-text-secondary">
            Short lessons, real code you run inline, and an AI that explains
            things differently when you're stuck. No wall of text, no setup,
            just you and the editor.
          </p>
          <div className="mt-8 flex flex-wrap gap-3">
            <Link
              to="/signup"
              className="forge-button px-5 py-3"
            >
              Start learning
            </Link>
            <a
              href="#bundles"
              className="forge-button-secondary px-5 py-3"
            >
              See what's covered
            </a>
          </div>
          <div className="mt-9 grid max-w-md grid-cols-3 gap-2 border-t border-border pt-5 text-sm">
            <div><p className="font-heading text-2xl text-accent">short</p><p className="text-text-secondary">lessons</p></div>
            <div><p className="font-heading text-2xl text-accent">real</p><p className="text-text-secondary">editor</p></div>
            <div><p className="font-heading text-2xl text-accent">human</p><p className="text-text-secondary">cohort</p></div>
          </div>
        </div>

        <div className="relative md:pl-4"><div className="absolute -inset-4 -z-10 rounded-[2rem] border border-accent/15 bg-accent/5" /><IdeMockup /></div>
      </section>

      <section className="mx-auto grid max-w-6xl gap-3 px-5 pb-10 sm:grid-cols-3 sm:px-8">
        {[
          [CodeIcon, 'Run it now', 'No setup or laptop-only exercises.'],
          [SparkleIcon, 'Get unstuck', 'Ask for a clearer explanation mid-lesson.'],
          [BookIcon, 'Keep proof', 'Track real progress and earn certificates.'],
        ].map(([Icon, title, copy]) => {
          const FeatureIcon = Icon as typeof CodeIcon
          return <div key={title as string} className="forge-card flex gap-3 p-4"><span className="forge-icon-tile h-10 w-10 shrink-0"><FeatureIcon size={19} /></span><div><h2 className="font-heading text-lg">{title as string}</h2><p className="text-sm text-text-secondary">{copy as string}</p></div></div>
        })}
      </section>

      {/* Bundles */}
      <section id="bundles" className="mx-auto max-w-6xl px-5 py-16 sm:px-8">
        <div className="mb-10 max-w-xl">
          <p className="page-kicker">Choose your build path</p>
          <h2 className="mt-2 font-heading text-4xl text-text">Pick a path</h2>
          <p className="mt-2 text-text-secondary">
            Every bundle is cohort-based, beginner-friendly, and built the same
            way: read a little, run real code, get unstuck fast.
          </p>
        </div>

        {bundlesLoading ? (
          <div className="grid gap-5 sm:grid-cols-2 lg:grid-cols-3">
            {Array.from({ length: 6 }).map((_, i) => (
              <div
                key={i}
                className="h-52 animate-pulse rounded-2xl border border-border bg-surface"
              />
            ))}
          </div>
        ) : (
          <div className="grid gap-5 sm:grid-cols-2 lg:grid-cols-3">
            {bundles.map((bundle) => (
              <BundleCard key={bundle.id} bundle={bundle} />
            ))}
          </div>
        )}
      </section>

      <footer className="border-t border-border px-6 py-8 text-center text-sm text-text-secondary">
        Forge: cohort-based coding education.
      </footer>
    </div>
  )
}
