import { Link, Navigate } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'
import { useActiveBundles } from '../lib/bundles'
import { ForgeMark } from '../components/icons'
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
    <div className="bg-background">
      <header className="mx-auto flex max-w-6xl items-center gap-2 px-6 py-5">
        <ForgeMark className="text-accent" size={24} />
        <span className="font-heading text-lg text-text">Forge</span>
        <nav className="ml-auto flex items-center gap-3 text-sm">
          <Link to="/login" className="text-text-secondary hover:text-text">
            Log in
          </Link>
          <Link
            to="/signup"
            className="rounded-lg bg-accent px-3.5 py-2 font-medium text-background hover:opacity-90"
          >
            Get started
          </Link>
        </nav>
      </header>

      {/* Hero */}
      <section className="mx-auto grid max-w-6xl gap-12 px-6 pb-20 pt-10 md:grid-cols-2 md:items-center md:pt-16">
        <div>
          <h1 className="font-heading text-4xl leading-tight text-text md:text-5xl">
            Learn to code by actually{' '}
            <span className="text-accent">writing code</span>.
          </h1>
          <p className="mt-5 text-lg text-text-secondary">
            Short lessons, real code you run inline, and an AI that explains
            things differently when you're stuck. No wall of text, no setup,
            just you and the editor.
          </p>
          <div className="mt-8 flex flex-wrap gap-3">
            <Link
              to="/signup"
              className="rounded-lg bg-accent px-5 py-3 font-medium text-background hover:opacity-90"
            >
              Start learning
            </Link>
            <a
              href="#bundles"
              className="rounded-lg border border-border px-5 py-3 text-text hover:bg-surface"
            >
              See what's covered
            </a>
          </div>
        </div>

        <IdeMockup />
      </section>

      {/* Bundles */}
      <section id="bundles" className="mx-auto max-w-6xl px-6 py-16">
        <div className="mb-10 max-w-xl">
          <h2 className="font-heading text-3xl text-text">Pick a path</h2>
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
