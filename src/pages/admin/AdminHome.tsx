import { useAuth } from '../../contexts/AuthContext'

export function AdminHome() {
  const { profile } = useAuth()

  return (
    <div className="px-6 py-10">
      <h1 className="font-heading text-2xl text-text">
        Instructor dashboard: {profile?.full_name}
      </h1>
      <p className="mt-2 max-w-lg text-text-secondary">
        This is a placeholder. The real instructor home (pending approvals,
        pending grading, inactive-student alerts, quick stats) is built out in
        Phase 6.
      </p>
    </div>
  )
}
