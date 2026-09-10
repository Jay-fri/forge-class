import { useEffect, useState, type FormEvent } from 'react'
import { Link, Navigate, useNavigate, useSearchParams } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'
import { useActiveBundles, formatPrice } from '../lib/bundles'
import { ForgeMark, SpinnerIcon } from '../components/icons'
import { TechIconCluster } from '../components/marketing/TechIconCluster'

export function Signup() {
  const { session, profile, loading, signUpWithPassword } = useAuth()
  const { bundles, loading: bundlesLoading } = useActiveBundles()
  const [searchParams] = useSearchParams()
  const navigate = useNavigate()

  const [step, setStep] = useState<'bundle' | 'details'>('bundle')
  const [bundleId, setBundleId] = useState<string | null>(null)

  const [fullName, setFullName] = useState('')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [submitting, setSubmitting] = useState(false)
  const [confirmationSent, setConfirmationSent] = useState(false)

  // Pre-select a bundle if the student arrived from a landing-page card,
  // and skip straight to account details.
  useEffect(() => {
    if (bundlesLoading || !bundles.length || step !== 'bundle' || bundleId) return
    const preselectSlug = searchParams.get('bundle')
    const preselected = bundles.find((b) => b.slug === preselectSlug)
    if (preselected) {
      setBundleId(preselected.id)
      setStep('details')
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [bundlesLoading, bundles])

  // Same reasoning as Login: wait for the profile fetch before redirecting
  // an already-signed-in visitor, and send them to the right place for
  // their role/approval status rather than always /home.
  if (session && !loading) {
    if (!profile) return null
    if (profile.role === 'instructor') return <Navigate to="/admin" replace />
    if (profile.approval_status === 'approved') return <Navigate to="/home" replace />
    return <Navigate to="/pending" replace />
  }

  const selectedBundle = bundles.find((b) => b.id === bundleId) ?? null

  async function handleSubmit(e: FormEvent) {
    e.preventDefault()
    setError(null)
    setSubmitting(true)
    const { error, needsEmailConfirmation } = await signUpWithPassword(
      email,
      password,
      fullName,
      bundleId,
    )
    setSubmitting(false)
    if (error) {
      setError(error)
      return
    }
    if (needsEmailConfirmation) {
      setConfirmationSent(true)
      return
    }
    navigate('/pending')
  }

  if (confirmationSent) {
    return (
      <div className="flex min-h-svh flex-col items-center justify-center gap-3 bg-background px-6 text-center">
        <ForgeMark className="text-accent" size={36} />
        <h1 className="font-heading text-2xl text-text">Check your email</h1>
        <p className="max-w-sm text-sm text-text-secondary">
          We sent a confirmation link to <span className="text-text">{email}</span>.
          Click it, then come back and log in.
        </p>
        <Link to="/login" className="mt-2 text-sm text-accent hover:underline">
          Back to log in
        </Link>
      </div>
    )
  }

  if (step === 'bundle') {
    return (
      <div className="mx-auto max-w-3xl px-6 py-12">
        <div className="mb-8 flex flex-col items-center gap-3 text-center">
          <ForgeMark className="text-accent" size={36} />
          <h1 className="font-heading text-2xl text-text">Pick your bundle</h1>
          <p className="text-sm text-text-secondary">
            You'll see the price now, and payment is arranged over WhatsApp
            after you sign up.
          </p>
        </div>

        {bundlesLoading ? (
          <div className="grid gap-3 sm:grid-cols-2">
            {Array.from({ length: 6 }).map((_, i) => (
              <div key={i} className="h-24 animate-pulse rounded-xl border border-border bg-surface" />
            ))}
          </div>
        ) : (
          <div className="grid gap-3 sm:grid-cols-2">
            {bundles.map((b) => (
              <button
                key={b.id}
                type="button"
                onClick={() => setBundleId(b.id)}
                className={`flex flex-col items-start gap-1 rounded-xl border px-4 py-3.5 text-left transition-colors ${
                  bundleId === b.id
                    ? 'border-accent bg-accent/10'
                    : 'border-border bg-surface hover:border-accent/40'
                }`}
              >
                <span className="flex w-full items-center justify-between">
                  <span className="flex items-center gap-2.5">
                    <TechIconCluster slug={b.slug} size={14} chip={28} />
                    <span className="font-heading text-lg text-text">{b.name}</span>
                  </span>
                  <span className="text-sm text-accent">
                    {formatPrice(b.price, b.currency)}
                  </span>
                </span>
                {b.description && (
                  <span className="text-sm text-text-secondary">{b.description}</span>
                )}
              </button>
            ))}
          </div>
        )}

        <button
          type="button"
          disabled={!bundleId}
          onClick={() => setStep('details')}
          className="mt-8 w-full rounded-lg bg-accent px-4 py-2.5 font-medium text-background transition-opacity hover:opacity-90 disabled:opacity-40 sm:w-auto"
        >
          Continue
        </button>

        <p className="mt-6 text-center text-sm text-text-secondary">
          Already have an account?{' '}
          <Link to="/login" className="text-accent hover:underline">
            Log in
          </Link>
        </p>
      </div>
    )
  }

  return (
    <div className="flex min-h-svh flex-col items-center justify-center bg-background px-6">
      <div className="w-full max-w-sm">
        <div className="mb-8 flex flex-col items-center gap-3 text-center">
          <ForgeMark className="text-accent" size={36} />
          <h1 className="font-heading text-2xl text-text">Create your account</h1>
          {selectedBundle && (
            <p className="text-sm text-text-secondary">
              {selectedBundle.name}:{' '}
              {formatPrice(selectedBundle.price, selectedBundle.currency)}{' '}
              <button
                type="button"
                onClick={() => setStep('bundle')}
                className="text-accent hover:underline"
              >
                change
              </button>
            </p>
          )}
        </div>

        <form onSubmit={handleSubmit} className="flex flex-col gap-4">
          <label className="flex flex-col gap-1.5 text-sm text-text-secondary">
            Full name
            <input
              type="text"
              required
              autoComplete="name"
              value={fullName}
              onChange={(e) => setFullName(e.target.value)}
              className="rounded-lg border border-border bg-surface px-3.5 py-2.5 text-text outline-none focus:border-accent"
            />
          </label>

          <label className="flex flex-col gap-1.5 text-sm text-text-secondary">
            Email
            <input
              type="email"
              required
              autoComplete="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="rounded-lg border border-border bg-surface px-3.5 py-2.5 text-text outline-none focus:border-accent"
            />
          </label>

          <label className="flex flex-col gap-1.5 text-sm text-text-secondary">
            Password
            <input
              type="password"
              required
              minLength={6}
              autoComplete="new-password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="rounded-lg border border-border bg-surface px-3.5 py-2.5 text-text outline-none focus:border-accent"
            />
          </label>

          {error && <p className="text-sm text-red-400">{error}</p>}

          <button
            type="submit"
            disabled={submitting}
            className="mt-2 flex items-center justify-center gap-2 rounded-lg bg-accent px-4 py-2.5 font-medium text-background transition-opacity hover:opacity-90 disabled:opacity-60"
          >
            {submitting && <SpinnerIcon className="animate-spin" size={16} />}
            Sign up
          </button>
        </form>

        <p className="mt-6 text-center text-sm text-text-secondary">
          Already have an account?{' '}
          <Link to="/login" className="text-accent hover:underline">
            Log in
          </Link>
        </p>
      </div>
    </div>
  )
}
