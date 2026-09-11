import { useEffect, useState } from 'react'
import { supabase } from '../../lib/supabase'
import { SpinnerIcon } from '../../components/icons'

interface TrackCompletion {
  name: string
  enrolled: number
  completed: number
}

interface DropOff {
  lessonTitle: string
  sectionTitle: string
  startedCount: number
  finishedCount: number
}

function averageDays(diffsMs: number[]) {
  if (diffsMs.length === 0) return null
  const avgMs = diffsMs.reduce((a, b) => a + b, 0) / diffsMs.length
  return avgMs / (1000 * 60 * 60 * 24)
}

export function Analytics() {
  const [loading, setLoading] = useState(true)
  const [timeToApproval, setTimeToApproval] = useState<number | null>(null)
  const [gradingTurnaround, setGradingTurnaround] = useState<number | null>(null)
  const [inactiveCount, setInactiveCount] = useState(0)
  const [trackCompletions, setTrackCompletions] = useState<TrackCompletion[]>([])
  const [dropOffs, setDropOffs] = useState<DropOff[]>([])

  useEffect(() => {
    async function load() {
      const [
        { data: profiles },
        { data: studentBundles },
        { data: approvalEvents },
        { data: submissions },
        { data: streaks },
        { data: tracks },
        { data: bundleTracks },
        { data: modules },
        { data: lessons },
        { data: sections },
        { data: progress },
      ] = await Promise.all([
        supabase.from('profiles').select('*').eq('role', 'student'),
        supabase.from('student_bundles').select('student_id, bundle_id'),
        supabase
          .from('audit_log')
          .select('entity_id, detail, created_at')
          .eq('action', 'approval_status_changed'),
        supabase.from('submissions').select('submitted_at, graded_at').eq('status', 'graded'),
        supabase.from('streaks').select('user_id, last_active_date'),
        supabase.from('tracks').select('*'),
        supabase.from('bundle_tracks').select('*'),
        supabase.from('modules').select('id, track_id'),
        supabase.from('lessons').select('id, title, module_id, order_index').order('order_index'),
        supabase.from('sections').select('id, title, lesson_id, order_index').order('order_index'),
        supabase.from('user_progress').select('user_id, section_id').eq('status', 'completed'),
      ])

      const bundleIdsByStudent = new Map<string, string[]>()
      for (const sb of studentBundles ?? []) {
        bundleIdsByStudent.set(sb.student_id, [...(bundleIdsByStudent.get(sb.student_id) ?? []), sb.bundle_id])
      }

      // Time to approval: created_at -> first approval_status_changed(to='approved') per student.
      const approvalDiffs: number[] = []
      for (const p of profiles ?? []) {
        const events = (approvalEvents ?? [])
          .filter((e) => e.entity_id === p.id && (e.detail as { to?: string })?.to === 'approved')
          .sort((a, b) => new Date(a.created_at).getTime() - new Date(b.created_at).getTime())
        if (events[0]) {
          approvalDiffs.push(
            new Date(events[0].created_at).getTime() - new Date(p.created_at).getTime(),
          )
        }
      }
      setTimeToApproval(averageDays(approvalDiffs))

      // Grading turnaround.
      const gradingDiffs = (submissions ?? [])
        .filter((s) => s.graded_at)
        .map((s) => new Date(s.graded_at!).getTime() - new Date(s.submitted_at).getTime())
      setGradingTurnaround(averageDays(gradingDiffs))

      // Inactive: approved students with no activity in 7+ days (or none ever).
      const weekAgo = Date.now() - 7 * 24 * 60 * 60 * 1000
      const approvedStudents = (profiles ?? []).filter((p) => p.approval_status === 'approved')
      const inactive = approvedStudents.filter((p) => {
        const streak = streaks?.find((s) => s.user_id === p.id)
        if (!streak?.last_active_date) return true
        return new Date(streak.last_active_date).getTime() < weekAgo
      })
      setInactiveCount(inactive.length)

      // Per-track completion rate among enrolled (assigned to a bundle covering the track).
      const sectionsByLesson = new Map<string, string[]>()
      for (const s of sections ?? []) {
        sectionsByLesson.set(s.lesson_id, [...(sectionsByLesson.get(s.lesson_id) ?? []), s.id])
      }
      const lessonsByModule = new Map<string, string[]>()
      for (const l of lessons ?? []) {
        lessonsByModule.set(l.module_id, [...(lessonsByModule.get(l.module_id) ?? []), l.id])
      }
      const modulesByTrack = new Map<string, string[]>()
      for (const m of modules ?? []) {
        modulesByTrack.set(m.track_id, [...(modulesByTrack.get(m.track_id) ?? []), m.id])
      }

      setTrackCompletions(
        (tracks ?? []).map((t) => {
          const bundleIds = (bundleTracks ?? []).filter((bt) => bt.track_id === t.id).map((bt) => bt.bundle_id)
          const enrolledStudents = approvedStudents.filter((p) =>
            (bundleIdsByStudent.get(p.id) ?? []).some((id) => bundleIds.includes(id)),
          )
          const moduleIds = modulesByTrack.get(t.id) ?? []
          const lessonIds = moduleIds.flatMap((mId) => lessonsByModule.get(mId) ?? [])
          const trackSectionIds = lessonIds.flatMap((lId) => sectionsByLesson.get(lId) ?? [])

          const completedCount = enrolledStudents.filter((student) => {
            const studentSections = (progress ?? []).filter((p) => p.user_id === student.id)
            const studentCompletedIds = new Set(studentSections.map((p) => p.section_id))
            return (
              trackSectionIds.length > 0 &&
              trackSectionIds.every((sid) => studentCompletedIds.has(sid))
            )
          }).length

          return { name: t.name, enrolled: enrolledStudents.length, completed: completedCount }
        }),
      )

      // Drop-off: for each lesson's sections in order, how many distinct
      // students finished each one — the biggest fall between consecutive
      // sections is the drop-off point.
      const dropOffCandidates: DropOff[] = []
      for (const l of lessons ?? []) {
        const secIds = (sections ?? [])
          .filter((s) => s.lesson_id === l.id)
          .sort((a, b) => a.order_index - b.order_index)
        const counts = secIds.map(
          (s) => new Set((progress ?? []).filter((p) => p.section_id === s.id).map((p) => p.user_id)).size,
        )
        for (let i = 1; i < counts.length; i++) {
          const fall = counts[i - 1] - counts[i]
          if (fall > 0) {
            dropOffCandidates.push({
              lessonTitle: l.title,
              sectionTitle: secIds[i].title ?? `Section ${i + 1}`,
              startedCount: counts[i - 1],
              finishedCount: counts[i],
            })
          }
        }
      }
      dropOffCandidates.sort((a, b) => b.startedCount - b.finishedCount - (a.startedCount - a.finishedCount))
      setDropOffs(dropOffCandidates.slice(0, 5))

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
      <h1 className="font-heading text-2xl text-text">Analytics</h1>

      <div className="mt-6 grid grid-cols-2 gap-3 lg:grid-cols-3">
        <div className="rounded-xl border border-border bg-surface px-4 py-4">
          <p className="text-xs text-text-secondary">Time to approval</p>
          <p className="mt-1 text-2xl text-text">
            {timeToApproval !== null ? `${timeToApproval.toFixed(1)}d` : 'N/A'}
          </p>
        </div>
        <div className="rounded-xl border border-border bg-surface px-4 py-4">
          <p className="text-xs text-text-secondary">Grading turnaround</p>
          <p className="mt-1 text-2xl text-text">
            {gradingTurnaround !== null ? `${gradingTurnaround.toFixed(1)}d` : 'N/A'}
          </p>
        </div>
        <div className="rounded-xl border border-border bg-surface px-4 py-4">
          <p className="text-xs text-text-secondary">Inactive students</p>
          <p className="mt-1 text-2xl text-text">{inactiveCount}</p>
          <p className="text-xs text-text-secondary">7+ days quiet</p>
        </div>
      </div>

      <h2 className="mt-8 font-heading text-lg text-text">Track completion</h2>
      <div className="mt-3 flex flex-col gap-3">
        {trackCompletions.map((t) => {
          const pct = t.enrolled > 0 ? Math.round((t.completed / t.enrolled) * 100) : 0
          return (
            <div key={t.name} className="rounded-xl border border-border bg-surface px-4 py-3">
              <div className="flex items-center justify-between gap-3">
                <p className="min-w-0 truncate text-text">{t.name}</p>
                <span className="shrink-0 text-sm text-text-secondary">
                  {t.completed}/{t.enrolled} ({pct}%)
                </span>
              </div>
              <div className="mt-2 h-1.5 rounded-full bg-border">
                <div className="h-full rounded-full bg-accent" style={{ width: `${pct}%` }} />
              </div>
            </div>
          )
        })}
        {trackCompletions.length === 0 && <p className="text-text-secondary">No tracks yet.</p>}
      </div>

      <h2 className="mt-8 font-heading text-lg text-text">Biggest drop-off points</h2>
      <div className="mt-3 flex flex-col gap-2">
        {dropOffs.map((d, i) => (
          <div key={i} className="rounded-xl border border-border bg-surface px-4 py-3">
            <p className="text-text">
              {d.lessonTitle} · {d.sectionTitle}
            </p>
            <p className="text-sm text-text-secondary">
              {d.startedCount} reached this lesson, {d.finishedCount} finished this section
            </p>
          </div>
        ))}
        {dropOffs.length === 0 && (
          <p className="text-text-secondary">Not enough activity yet to spot drop-off points.</p>
        )}
      </div>
    </div>
  )
}
