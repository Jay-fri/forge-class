import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { useAuth } from '../../contexts/AuthContext'
import { supabase } from '../../lib/supabase'
import {
  CheckCircleIcon,
  InboxIcon,
  MessageIcon,
  SpinnerIcon,
} from '../../components/icons'

export function AdminHome() {
  const { profile } = useAuth()
  const [loading, setLoading] = useState(true)
  const [pendingApprovals, setPendingApprovals] = useState(0)
  const [pendingGrading, setPendingGrading] = useState(0)
  const [openFeedback, setOpenFeedback] = useState(0)
  const [inactiveStudents, setInactiveStudents] = useState(0)
  const [totalStudents, setTotalStudents] = useState(0)

  useEffect(() => {
    async function load() {
      const [
        { count: approvals },
        { count: grading },
        { count: feedback },
        { data: approvedStudents },
        { data: streaks },
        { count: students },
      ] = await Promise.all([
        supabase.from('profiles').select('id', { count: 'exact', head: true }).eq('role', 'student').eq('approval_status', 'pending'),
        supabase.from('submissions').select('id', { count: 'exact', head: true }).neq('status', 'graded'),
        supabase.from('content_feedback').select('id', { count: 'exact', head: true }).eq('status', 'open'),
        supabase.from('profiles').select('id').eq('role', 'student').eq('approval_status', 'approved'),
        supabase.from('streaks').select('user_id, last_active_date'),
        supabase.from('profiles').select('id', { count: 'exact', head: true }).eq('role', 'student'),
      ])

      const weekAgo = Date.now() - 7 * 24 * 60 * 60 * 1000
      const inactive = (approvedStudents ?? []).filter((p) => {
        const streak = streaks?.find((s) => s.user_id === p.id)
        if (!streak?.last_active_date) return true
        return new Date(streak.last_active_date).getTime() < weekAgo
      })

      setPendingApprovals(approvals ?? 0)
      setPendingGrading(grading ?? 0)
      setOpenFeedback(feedback ?? 0)
      setInactiveStudents(inactive.length)
      setTotalStudents(students ?? 0)
      setLoading(false)
    }
    load()
  }, [])

  if (loading) {
    return (
      <div className="flex justify-center py-20 text-accent">
        <SpinnerIcon className="animate-spin" size={24} />
      </div>
    )
  }

  return (
    <div className="px-6 py-8">
      <h1 className="font-heading text-2xl text-text">
        Welcome back, {profile?.full_name?.split(' ')[0]}
      </h1>
      <p className="mt-1 text-text-secondary">Here's what needs your attention.</p>

      <div className="mt-6 grid gap-3 sm:grid-cols-2 lg:grid-cols-4">
        <Link
          to="/admin/approvals"
          className="rounded-xl border border-border bg-surface px-4 py-4 transition-colors hover:border-accent/40"
        >
          <InboxIcon className={pendingApprovals > 0 ? 'text-accent' : 'text-text-secondary'} size={20} />
          <p className="mt-2 text-2xl text-text">{pendingApprovals}</p>
          <p className="text-sm text-text-secondary">Pending approvals</p>
        </Link>
        <Link
          to="/admin/grading"
          className="rounded-xl border border-border bg-surface px-4 py-4 transition-colors hover:border-accent/40"
        >
          <CheckCircleIcon className={pendingGrading > 0 ? 'text-accent' : 'text-text-secondary'} size={20} />
          <p className="mt-2 text-2xl text-text">{pendingGrading}</p>
          <p className="text-sm text-text-secondary">Pending grading</p>
        </Link>
        <Link
          to="/admin/content-feedback"
          className="rounded-xl border border-border bg-surface px-4 py-4 transition-colors hover:border-accent/40"
        >
          <MessageIcon className={openFeedback > 0 ? 'text-accent' : 'text-text-secondary'} size={20} />
          <p className="mt-2 text-2xl text-text">{openFeedback}</p>
          <p className="text-sm text-text-secondary">Open feedback</p>
        </Link>
        <Link
          to="/admin/students"
          className="rounded-xl border border-border bg-surface px-4 py-4 transition-colors hover:border-accent/40"
        >
          <InboxIcon className={inactiveStudents > 0 ? 'text-accent' : 'text-text-secondary'} size={20} />
          <p className="mt-2 text-2xl text-text">{inactiveStudents}</p>
          <p className="text-sm text-text-secondary">Inactive students</p>
        </Link>
      </div>

      <p className="mt-6 text-sm text-text-secondary">{totalStudents} students total.</p>
    </div>
  )
}
