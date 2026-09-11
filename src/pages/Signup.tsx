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
  const [bundleIds, setBundleIds] = useState<string[]>([])

  const [fullName, setFullName] = useState('')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [submitting, setSubmitting] = useState(false)
  const [confirmationSent, setConfirmationSent] = useState(false)

  // Pre-select a bundle if the student arrived from a landing-page card,
  // and skip straight to account details.
  useEffect(() => {
    if (bundlesLoading || !bundles.length || step !== 'bundle' || bundleIds.length) return
    const preselectSlug = searchParams.get('bundle')
    const preselected = bundles.find((b) => b.slug === preselectSlug)
    if (preselected) {
      setBundleIds([preselected.id])
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

  const selectedBundles = bundles.filter((b) => bundleIds.includes(b.id))
  const totalPrice = selectedBundles.reduce((sum, b) => sum + b.price, 0)

  function toggleBundle(id: string) {
    setBundleIds((prev) => (prev.includes(id) ? prev.filter((b) => b !== id) : [...prev, id]))
  }

  async function handleSubmit(e: FormEvent) {
    e.preventDefault()
    setError(null)
    setSubmitting(true)
    const { error, needsEmailConfirmation } = await signUpWithPassword(
      email,
      password,
      fullName,
      bundleIds,
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
      <div className="forge-auth flex min-h-svh flex-col items-center justify-center gap-3 bg-background px-6 text-center">
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
      <div className="forge-auth min-h-svh bg-background px-5 py-8 sm:px-8 sm:py-14">
       <div className="mx-auto max-w-4xl">
        <div className="mb-8 flex flex-col items-center gap-3 text-center">
          <span className="forge-icon-tile h-12 w-12"><ForgeMark className="text-accent" size={28} /></span>
          <p className="page-kicker">Step 1 of 2</p>
          <h1 className="font-heading text-4xl text-text">Pick your bundle</h1>
          <p className="text-sm text-text-secondary">
            Select one or more. You'll see the price now, and payment is
            arranged over WhatsApp after you sign up.
          </p>
        </div>

        {bundlesLoading ? (
          <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
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
                onClick={() => toggleBundle(b.id)}
                className={`flex min-h-32 flex-col items-start gap-2 rounded-2xl border px-4 py-4 text-left transition-colors ${
                  bundleIds.includes(b.id)
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

        {selectedBundles.length > 0 && (
          <p className="mt-4 text-sm text-text-secondary">
            {selectedBundles.length} selected: total{' '}
            <span className="text-accent">{formatPrice(totalPrice, selectedBundles[0].currency)}</span>
          </p>
        )}

        <button
          type="button"
          disabled={bundleIds.length === 0}
          onClick={() => setStep('details')}
          className="forge-button mt-4 w-full disabled:opacity-40 sm:w-auto"
        >
          Continue
        </button>

        <p className="mt-6 text-center text-sm text-text-secondary">
          Already have an account?{' '}
          <Link to="/login" className="text-accent hover:underline">
            Log in
          </Link>
        </p>
       </div></div>
    )
  }

  return (
    <div className="forge-auth flex min-h-svh flex-col items-center justify-center bg-background px-5 py-8 sm:px-8">
      <div className="forge-card w-full max-w-md p-5 sm:p-7">
        <div className="mb-8 flex flex-col items-center gap-3 text-center">
          <span className="forge-icon-tile h-12 w-12"><ForgeMark className="text-accent" size={28} /></span>
          <p className="page-kicker">Step 2 of 2</p><h1 className="font-heading text-3xl text-text">Create your account</h1>
          {selectedBundles.length > 0 && (
            <p className="text-sm text-text-secondary">
              {selectedBundles.map((b) => b.name).join(', ')}:{' '}
              {formatPrice(totalPrice, selectedBundles[0].currency)}{' '}
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
              className="forge-input"
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
              className="forge-input"
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
              className="forge-input"
            />
          </label>

          {error && <p className="text-sm text-accent">{error}</p>}

          <button
            type="submit"
            disabled={submitting}
            className="forge-button mt-2 gap-2 disabled:opacity-60"
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
