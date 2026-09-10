import { useState, type FormEvent } from 'react'
import { Link, Navigate, useNavigate } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'
import { ForgeMark, SpinnerIcon } from '../components/icons'

export function Login() {
  const { session, profile, loading, signInWithPassword } = useAuth()
  const navigate = useNavigate()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [submitting, setSubmitting] = useState(false)

  // Wait for the profile fetch (loading) before deciding where an already
  // signed-in visitor belongs — redirecting on session alone can send a
  // pending/instructor account somewhere ProtectedRoute immediately bounces
  // it back from.
  if (session && !loading) {
    if (!profile) return null
    if (profile.role === 'instructor') return <Navigate to="/admin" replace />
    if (profile.approval_status === 'approved') return <Navigate to="/home" replace />
    return <Navigate to="/pending" replace />
  }

  async function handleSubmit(e: FormEvent) {
    e.preventDefault()
    setError(null)
    setSubmitting(true)
    const { error } = await signInWithPassword(email, password)
    setSubmitting(false)
    if (error) {
      setError(error)
      return
    }
    navigate('/home')
  }

  return (
    <div className="forge-auth flex min-h-svh flex-col items-center justify-center bg-background px-5 py-8 sm:px-8">
      <div className="forge-card w-full max-w-md p-5 sm:p-7">
        <div className="mb-8 flex flex-col items-center gap-3 text-center">
          <span className="forge-icon-tile h-12 w-12"><ForgeMark className="text-accent" size={28} /></span>
          <p className="page-kicker">Your learning space</p><h1 className="font-heading text-3xl text-text">Welcome back</h1>
          <p className="text-sm text-text-secondary">
            Log in to keep building your streak.
          </p>
        </div>

        <form onSubmit={handleSubmit} className="flex flex-col gap-4">
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
              autoComplete="current-password"
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
            Log in
          </button>
        </form>

        <p className="mt-6 text-center text-sm text-text-secondary">
          New to Forge?{' '}
          <Link to="/signup" className="text-accent hover:underline">
            Create an account
          </Link>
        </p>
      </div>
    </div>
  )
}
