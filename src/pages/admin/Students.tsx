import { useEffect, useState } from 'react'
import { supabase } from '../../lib/supabase'
import { formatPrice } from '../../lib/bundles'
import type { ApprovalStatus, Database } from '../../lib/database.types'
import { SpinnerIcon } from '../../components/icons'

type Profile = Database['public']['Tables']['profiles']['Row']
type Bundle = Database['public']['Tables']['bundles']['Row']
type Track = Database['public']['Tables']['tracks']['Row']
type Submission = Database['public']['Tables']['submissions']['Row']

interface StudentRow extends Profile {
  bundleIds: string[]
  bundleNames: string[]
}

export function Students() {
  const [students, setStudents] = useState<StudentRow[]>([])
  const [bundles, setBundles] = useState<Bundle[]>([])
  const [loading, setLoading] = useState(true)
  const [search, setSearch] = useState('')
  const [statusFilter, setStatusFilter] = useState<ApprovalStatus | 'all'>('all')
  const [bundleFilter, setBundleFilter] = useState<string>('all')
  const [selectedId, setSelectedId] = useState<string | null>(null)

  async function load() {
    setLoading(true)
    const [{ data: profileRows }, { data: bundleRows }, { data: sbRows }] = await Promise.all([
      supabase.from('profiles').select('*').eq('role', 'student').order('created_at', { ascending: false }),
      supabase.from('bundles').select('*'),
      supabase.from('student_bundles').select('student_id, bundle_id'),
    ])
    setBundles(bundleRows ?? [])
    setStudents(
      (profileRows ?? []).map((p) => {
        const bundleIds = (sbRows ?? []).filter((sb) => sb.student_id === p.id).map((sb) => sb.bundle_id)
        return {
          ...p,
          bundleIds,
          bundleNames: bundleIds
            .map((id) => bundleRows?.find((b) => b.id === id)?.name)
            .filter((n): n is string => Boolean(n)),
        }
      }),
    )
    setLoading(false)
  }

  useEffect(() => {
    load()
  }, [])

  const filtered = students.filter((s) => {
    if (statusFilter !== 'all' && s.approval_status !== statusFilter) return false
    if (bundleFilter !== 'all' && !s.bundleIds.includes(bundleFilter)) return false
    if (search && !`${s.full_name} ${s.email}`.toLowerCase().includes(search.toLowerCase())) return false
    return true
  })

  if (selectedId) {
    return <StudentProfile studentId={selectedId} onBack={() => setSelectedId(null)} />
  }

  if (loading) {
    return (
      <div className="flex justify-center py-20 text-accent">
        <SpinnerIcon className="animate-spin" size={24} />
      </div>
    )
  }

  return (
    <div className="px-6 py-8">
      <h1 className="font-heading text-2xl text-text">Students</h1>
      <p className="mt-1 text-text-secondary">{filtered.length} of {students.length}</p>

      <div className="mt-4 flex flex-wrap gap-2">
        <input
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          placeholder="Search by name or email"
          className="flex-1 rounded-lg border border-border bg-surface px-3.5 py-2 text-sm text-text outline-none focus:border-accent"
        />
        <select
          value={statusFilter}
          onChange={(e) => setStatusFilter(e.target.value as ApprovalStatus | 'all')}
          className="rounded-lg border border-border bg-surface px-3 py-2 text-sm capitalize text-text"
        >
          <option value="all">All statuses</option>
          <option value="pending">Pending</option>
          <option value="approved">Approved</option>
          <option value="rejected">Rejected</option>
        </select>
        <select
          value={bundleFilter}
          onChange={(e) => setBundleFilter(e.target.value)}
          className="rounded-lg border border-border bg-surface px-3 py-2 text-sm text-text"
        >
          <option value="all">All bundles</option>
          {bundles.map((b) => (
            <option key={b.id} value={b.id}>
              {b.name}
            </option>
          ))}
        </select>
      </div>

      <div className="mt-4 flex flex-col gap-2">
        {filtered.map((s) => (
          <button
            key={s.id}
            onClick={() => setSelectedId(s.id)}
            className="flex flex-col gap-2 rounded-xl border border-border bg-surface px-4 py-3 text-left transition-colors hover:border-accent/40 sm:flex-row sm:items-center sm:justify-between"
          >
            <div className="min-w-0">
              <p className="truncate font-medium text-text">{s.full_name}</p>
              <p className="truncate text-sm text-text-secondary">{s.email}</p>
            </div>
            <div className="flex flex-wrap items-center gap-2">
              {s.bundleNames.map((name) => (
                <span key={name} className="rounded-full border border-border px-2.5 py-1 text-xs text-text-secondary">
                  {name}
                </span>
              ))}
              <span
                className={`shrink-0 rounded-full border px-2.5 py-1 text-xs capitalize ${
                  s.approval_status === 'approved'
                    ? 'border-success/40 text-success'
                    : s.approval_status === 'pending'
                      ? 'border-accent/40 text-accent'
                      : 'border-border text-text-secondary'
                }`}
              >
                {s.approval_status}
              </span>
            </div>
          </button>
        ))}
        {filtered.length === 0 && (
          <p className="py-10 text-center text-text-secondary">No students match.</p>
        )}
      </div>
    </div>
  )
}

function StudentProfile({ studentId, onBack }: { studentId: string; onBack: () => void }) {
  const [profile, setProfile] = useState<Profile | null>(null)
  const [allBundles, setAllBundles] = useState<Bundle[]>([])
  const [studentBundleIds, setStudentBundleIds] = useState<string[]>([])
  const [allTracks, setAllTracks] = useState<Track[]>([])
  const [grantedTrackIds, setGrantedTrackIds] = useState<string[]>([])
  const [addBundleId, setAddBundleId] = useState('')
  const [addTrackId, setAddTrackId] = useState('')
  const [streak, setStreak] = useState({ current: 0, longest: 0 })
  const [trackProgress, setTrackProgress] = useState<{ name: string; pct: number }[]>([])
  const [submissions, setSubmissions] = useState<(Submission & { assignmentTitle: string })[]>([])
  const [cohortHistory, setCohortHistory] = useState<string[]>([])
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState(false)

  async function load() {
    const { data: profileRow } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', studentId)
      .maybeSingle()
    setProfile(profileRow)
    if (!profileRow) {
      setLoading(false)
      return
    }

    const [
      { data: bundleRows },
      { data: sbRows },
      { data: trackRows },
      { data: grantRows },
      { data: streakRow },
      { data: modules },
      { data: lessons },
      { data: sections },
      { data: progress },
      { data: submissionRows },
      { data: memberships },
    ] = await Promise.all([
      supabase.from('bundles').select('*'),
      supabase.from('student_bundles').select('bundle_id').eq('student_id', studentId),
      supabase.from('tracks').select('*').order('order_index'),
      supabase.from('student_track_grants').select('track_id').eq('student_id', studentId),
      supabase.from('streaks').select('current_streak, longest_streak').eq('user_id', studentId).maybeSingle(),
      supabase.from('modules').select('id, track_id'),
      supabase.from('lessons').select('id, module_id'),
      supabase.from('sections').select('id, lesson_id'),
      supabase.from('user_progress').select('section_id').eq('user_id', studentId).eq('status', 'completed'),
      supabase.from('submissions').select('*, assignments(title)').eq('student_id', studentId),
      supabase.from('cohort_memberships').select('cohort_id, cohorts(name)').eq('student_id', studentId),
    ])

    setAllBundles(bundleRows ?? [])
    setStudentBundleIds((sbRows ?? []).map((sb) => sb.bundle_id))
    setAllTracks(trackRows ?? [])
    setGrantedTrackIds((grantRows ?? []).map((g) => g.track_id))
    setStreak(
      streakRow
        ? { current: streakRow.current_streak, longest: streakRow.longest_streak }
        : { current: 0, longest: 0 },
    )

    const completedIds = new Set((progress ?? []).map((p) => p.section_id))
    setTrackProgress(
      (trackRows ?? []).map((t) => {
        const moduleIds = (modules ?? []).filter((m) => m.track_id === t.id).map((m) => m.id)
        const lessonIds = (lessons ?? []).filter((l) => moduleIds.includes(l.module_id)).map((l) => l.id)
        const trackSections = (sections ?? []).filter((s) => lessonIds.includes(s.lesson_id))
        const pct = trackSections.length
          ? Math.round(
              (trackSections.filter((s) => completedIds.has(s.id)).length / trackSections.length) * 100,
            )
          : 0
        return { name: t.name, pct }
      }),
    )

    setSubmissions(
      ((submissionRows ?? []) as unknown as (Submission & { assignments: { title: string } | null })[]).map(
        (s) => ({ ...s, assignmentTitle: s.assignments?.title ?? 'Assignment' }),
      ),
    )
    setCohortHistory(
      ((memberships ?? []) as unknown as { cohorts: { name: string } | null }[])
        .map((m) => m.cohorts?.name)
        .filter((n): n is string => Boolean(n)),
    )
    setLoading(false)
  }

  useEffect(() => {
    load()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [studentId])

  async function addBundle() {
    if (!addBundleId) return
    setSaving(true)
    await supabase.from('student_bundles').insert({ student_id: studentId, bundle_id: addBundleId })
    setAddBundleId('')
    setSaving(false)
    load()
  }

  async function removeBundle(bundleId: string) {
    setSaving(true)
    await supabase.from('student_bundles').delete().eq('student_id', studentId).eq('bundle_id', bundleId)
    setSaving(false)
    load()
  }

  async function grantTrack() {
    if (!addTrackId) return
    setSaving(true)
    await supabase.from('student_track_grants').insert({ student_id: studentId, track_id: addTrackId })
    setAddTrackId('')
    setSaving(false)
    load()
  }

  async function revokeTrack(trackId: string) {
    setSaving(true)
    await supabase.from('student_track_grants').delete().eq('student_id', studentId).eq('track_id', trackId)
    setSaving(false)
    load()
  }

  if (loading || !profile) {
    return (
      <div className="flex justify-center py-20 text-accent">
        <SpinnerIcon className="animate-spin" size={24} />
      </div>
    )
  }

  const studentBundles = allBundles.filter((b) => studentBundleIds.includes(b.id))
  const availableBundlesToAdd = allBundles.filter((b) => !studentBundleIds.includes(b.id))
  const grantedTracks = allTracks.filter((t) => grantedTrackIds.includes(t.id))
  const availableTracksToGrant = allTracks.filter((t) => !grantedTrackIds.includes(t.id))

  return (
    <div className="px-6 py-8">
      <button onClick={onBack} className="text-sm text-text-secondary hover:text-text">
        ← Back to students
      </button>

      <div className="mt-3 flex items-center justify-between">
        <div>
          <h1 className="font-heading text-2xl text-text">{profile.full_name}</h1>
          <p className="text-text-secondary">{profile.email}</p>
        </div>
        <span
          className={`rounded-full border px-2.5 py-1 text-sm capitalize ${
            profile.approval_status === 'approved'
              ? 'border-success/40 text-success'
              : 'border-accent/40 text-accent'
          }`}
        >
          {profile.approval_status}
        </span>
      </div>

      <div className="mt-6 grid grid-cols-2 gap-3 sm:grid-cols-3">
        <div className="rounded-xl border border-border bg-surface px-4 py-3">
          <p className="text-xs text-text-secondary">Streak</p>
          <p className="mt-1 text-text">{streak.current} days (best {streak.longest})</p>
        </div>
        <div className="rounded-xl border border-border bg-surface px-4 py-3">
          <p className="text-xs text-text-secondary">Cohorts</p>
          <p className="mt-1 text-text">{cohortHistory.join(', ') || 'None'}</p>
        </div>
      </div>

      <h2 className="mt-8 font-heading text-lg text-text">Bundles</h2>
      <p className="mt-1 text-sm text-text-secondary">
        Every bundle this student has, from signup or granted here directly.
      </p>
      <div className="mt-3 flex flex-col gap-2">
        {studentBundles.map((b) => (
          <div key={b.id} className="flex items-center justify-between gap-3 rounded-xl border border-border bg-surface px-4 py-3">
            <p className="min-w-0 truncate text-text">
              {b.name} <span className="text-text-secondary">({formatPrice(b.price, b.currency)})</span>
            </p>
            <button
              onClick={() => removeBundle(b.id)}
              disabled={saving}
              className="shrink-0 text-sm text-red-400 hover:underline disabled:opacity-50"
            >
              Remove
            </button>
          </div>
        ))}
        {studentBundles.length === 0 && (
          <p className="text-sm text-text-secondary">No bundles yet.</p>
        )}
      </div>
      {availableBundlesToAdd.length > 0 && (
        <div className="mt-2 flex gap-2">
          <select
            value={addBundleId}
            onChange={(e) => setAddBundleId(e.target.value)}
            className="flex-1 rounded-lg border border-border bg-surface px-3 py-2 text-sm text-text"
          >
            <option value="">Add a bundle…</option>
            {availableBundlesToAdd.map((b) => (
              <option key={b.id} value={b.id}>
                {b.name}
              </option>
            ))}
          </select>
          <button
            onClick={addBundle}
            disabled={!addBundleId || saving}
            className="rounded-lg bg-accent px-4 py-2 text-sm font-medium text-background hover:opacity-90 disabled:opacity-50"
          >
            Add
          </button>
        </div>
      )}

      <h2 className="mt-8 font-heading text-lg text-text">Individual track access</h2>
      <p className="mt-1 text-sm text-text-secondary">
        Grant access to one specific track outside of any bundle, for exceptions or one-off requests.
      </p>
      <div className="mt-3 flex flex-col gap-2">
        {grantedTracks.map((t) => (
          <div key={t.id} className="flex items-center justify-between gap-3 rounded-xl border border-border bg-surface px-4 py-3">
            <p className="min-w-0 truncate text-text">{t.name}</p>
            <button
              onClick={() => revokeTrack(t.id)}
              disabled={saving}
              className="shrink-0 text-sm text-red-400 hover:underline disabled:opacity-50"
            >
              Revoke
            </button>
          </div>
        ))}
        {grantedTracks.length === 0 && (
          <p className="text-sm text-text-secondary">No individual grants.</p>
        )}
      </div>
      {availableTracksToGrant.length > 0 && (
        <div className="mt-2 flex gap-2">
          <select
            value={addTrackId}
            onChange={(e) => setAddTrackId(e.target.value)}
            className="flex-1 rounded-lg border border-border bg-surface px-3 py-2 text-sm text-text"
          >
            <option value="">Grant a track…</option>
            {availableTracksToGrant.map((t) => (
              <option key={t.id} value={t.id}>
                {t.name}
              </option>
            ))}
          </select>
          <button
            onClick={grantTrack}
            disabled={!addTrackId || saving}
            className="rounded-lg bg-accent px-4 py-2 text-sm font-medium text-background hover:opacity-90 disabled:opacity-50"
          >
            Grant
          </button>
        </div>
      )}

      <h2 className="mt-8 font-heading text-lg text-text">Track progress</h2>
      <div className="mt-3 flex flex-col gap-3">
        {trackProgress.map((t) => (
          <div key={t.name} className="rounded-xl border border-border bg-surface px-4 py-3">
            <div className="flex items-center justify-between gap-3">
              <p className="min-w-0 truncate text-text">{t.name}</p>
              <span className="shrink-0 text-sm text-text-secondary">{t.pct}%</span>
            </div>
            <div className="mt-2 h-1.5 rounded-full bg-border">
              <div className="h-full rounded-full bg-accent" style={{ width: `${t.pct}%` }} />
            </div>
          </div>
        ))}
      </div>

      <h2 className="mt-8 font-heading text-lg text-text">Submissions</h2>
      <div className="mt-3 flex flex-col gap-2">
        {submissions.map((s) => (
          <div key={s.id} className="flex items-center justify-between gap-3 rounded-xl border border-border bg-surface px-4 py-3">
            <p className="min-w-0 truncate text-text">{s.assignmentTitle}</p>
            <span className="shrink-0 text-sm capitalize text-text-secondary">{s.status.replace('_', ' ')}</span>
          </div>
        ))}
        {submissions.length === 0 && <p className="text-text-secondary">No submissions yet.</p>}
      </div>
    </div>
  )
}
