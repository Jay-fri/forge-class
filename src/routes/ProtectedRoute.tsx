import { Navigate } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'
import { SpinnerIcon } from '../components/icons'
import type { UserRole } from '../lib/database.types'

export function ProtectedRoute({
  role,
  requireApproval = true,
  children,
}: {
  role: UserRole
  requireApproval?: boolean
  children: React.ReactNode
}) {
  const { session, profile, loading } = useAuth()

  if (loading) {
    return (
      <div className="flex min-h-svh items-center justify-center bg-background text-accent">
        <SpinnerIcon className="animate-spin" size={28} />
      </div>
    )
  }

  if (!session) return <Navigate to="/login" replace />
  if (!profile) return <Navigate to="/login" replace />

  if (profile.role !== role) {
    return <Navigate to={profile.role === 'instructor' ? '/admin' : '/home'} replace />
  }

  if (role === 'student' && requireApproval && profile.approval_status !== 'approved') {
    return <Navigate to="/pending" replace />
  }

  if (role === 'student' && !requireApproval && profile.approval_status === 'approved') {
    return <Navigate to="/home" replace />
  }

  return <>{children}</>
}
