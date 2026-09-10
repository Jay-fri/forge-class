import { useEffect, useState } from 'react'
import { supabase } from '../../lib/supabase'
import { formatPrice } from '../../lib/bundles'
import type {
  CohortStatus,
  ContentDropMode,
  Database,
  LateJoinDecision,
} from '../../lib/database.types'
import { SpinnerIcon } from '../../components/icons'

type Cohort = Database['public']['Tables']['cohorts']['Row']
type Bundle = Database['public']['Tables']['bundles']['Row']
type Membership = Database['public']['Tables']['cohort_memberships']['Row']
type Profile = Database['public']['Tables']['profiles']['Row']

interface CohortWithBundle extends Cohort {
  bundleName: string
  memberCount: number
}

const statuses: CohortStatus[] = ['upcoming', 'active', 'completed']
const dropModes: ContentDropMode[] = ['weekly', 'all_at_once']
const lateDecisions: LateJoinDecision[] = ['waitlist', 'allow', 'allow_with_fee']

export function Cohorts() {
  const [cohorts, setCohorts] = useState<CohortWithBundle[]>([])
  const [bundles, setBundles] = useState<Bundle[]>([])
  const [loading, setLoading] = useState(true)
  const [creating, setCreating] = useState(false)
  const [draft, setDraft] = useState({
    bundle_id: '',
    name: '',
    start_date: '',
    end_date: '',
    content_drop_mode: 'weekly' as ContentDropMode,
  })
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [selectedId, setSelectedId] = useState<string | null>(null)

  async function load() {
    setLoading(true)
    const [{ data: cohortRows }, { data: bundleRows }, { data: memberRows }] = await Promise.all([
      supabase.from('cohorts').select('*').order('start_date', { ascending: false }),
      supabase.from('bundles').select('*').order('price'),
      supabase.from('cohort_memberships').select('cohort_id'),
    ])
    setBundles(bundleRows ?? [])
    setCohorts(
      (cohortRows ?? []).map((c) => ({
        ...c,
        bundleName: bundleRows?.find((b) => b.id === c.bundle_id)?.name ?? 'Unknown bundle',
        memberCount: (memberRows ?? []).filter((m) => m.cohort_id === c.id).length,
      })),
    )
    setLoading(false)
  }

  useEffect(() => {
    load()
  }, [])

  async function createCohort() {
    setSaving(true)
    setError(null)
    try {
      const { error: err } = await supabase.from('cohorts').insert({
        bundle_id: draft.bundle_id,
        name: draft.name,
        start_date: draft.start_date,
        end_date: draft.end_date,
        content_drop_mode: draft.content_drop_mode,
      })
      if (err) throw err
      setDraft({ bundle_id: '', name: '', start_date: '', end_date: '', content_drop_mode: 'weekly' })
      setCreating(false)
      await load()
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to create cohort.')
    } finally {
      setSaving(false)
    }
  }

  async function updateStatus(cohort: Cohort, status: CohortStatus) {
    await supabase.from('cohorts').update({ status }).eq('id', cohort.id)
    await load()
  }

  if (selectedId) {
    return (
      <CohortDetail
        cohortId={selectedId}
        onBack={() => {
          setSelectedId(null)
          load()
        }}
      />
    )
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
      <div className="flex items-center justify-between">
        <div>
          <h1 className="font-heading text-2xl text-text">Cohorts</h1>
          <p className="mt-1 text-text-secondary">One cohort per intake, per bundle.</p>
        </div>
        <button
          type="button"
          onClick={() => setCreating((c) => !c)}
          className="rounded-lg bg-accent px-4 py-2 text-sm font-medium text-background hover:opacity-90"
        >
          {creating ? 'Cancel' : 'New cohort'}
        </button>
      </div>

      {creating && (
        <div className="mt-6 flex flex-col gap-3 rounded-xl border border-border bg-surface p-4">
          <div className="grid gap-3 sm:grid-cols-2">
            <label className="flex flex-col gap-1 text-sm text-text-secondary">
              Bundle
              <select
                value={draft.bundle_id}
                onChange={(e) => setDraft((d) => ({ ...d, bundle_id: e.target.value }))}
                className="rounded-lg border border-border bg-background px-3 py-2 text-text"
              >
                <option value="">Select a bundle</option>
                {bundles.map((b) => (
                  <option key={b.id} value={b.id}>
                    {b.name}
                  </option>
                ))}
              </select>
            </label>
            <label className="flex flex-col gap-1 text-sm text-text-secondary">
              Name
              <input
                value={draft.name}
                onChange={(e) => setDraft((d) => ({ ...d, name: e.target.value }))}
                placeholder="e.g. Frontend, Oct 2026"
                className="rounded-lg border border-border bg-background px-3 py-2 text-text"
              />
            </label>
            <label className="flex flex-col gap-1 text-sm text-text-secondary">
              Start date
              <input
                type="date"
                value={draft.start_date}
                onChange={(e) => setDraft((d) => ({ ...d, start_date: e.target.value }))}
                className="rounded-lg border border-border bg-background px-3 py-2 text-text"
              />
            </label>
            <label className="flex flex-col gap-1 text-sm text-text-secondary">
              End date
              <input
                type="date"
                value={draft.end_date}
                onChange={(e) => setDraft((d) => ({ ...d, end_date: e.target.value }))}
                className="rounded-lg border border-border bg-background px-3 py-2 text-text"
              />
            </label>
          </div>
          <label className="flex flex-col gap-1 text-sm text-text-secondary">
            Content drop
            <select
              value={draft.content_drop_mode}
              onChange={(e) =>
                setDraft((d) => ({ ...d, content_drop_mode: e.target.value as ContentDropMode }))
              }
              className="w-fit rounded-lg border border-border bg-background px-3 py-2 text-text"
            >
              {dropModes.map((m) => (
                <option key={m} value={m}>
                  {m === 'weekly' ? 'Weekly drip' : 'All at once'}
                </option>
              ))}
            </select>
          </label>
          {error && <p className="text-sm text-red-400">{error}</p>}
          <button
            onClick={createCohort}
            disabled={saving || !draft.bundle_id || !draft.name || !draft.start_date || !draft.end_date}
            className="w-fit rounded-lg bg-accent px-4 py-2 text-sm font-medium text-background hover:opacity-90 disabled:opacity-50"
          >
            {saving ? 'Creating…' : 'Create cohort'}
          </button>
        </div>
      )}

      <div className="mt-6 flex flex-col gap-2">
        {cohorts.map((c) => (
          <div
            key={c.id}
            className="flex items-center justify-between rounded-xl border border-border bg-surface px-4 py-3"
          >
            <button
              type="button"
              onClick={() => setSelectedId(c.id)}
              className="text-left hover:text-accent"
            >
              <p className="font-medium text-text">{c.name}</p>
              <p className="text-sm text-text-secondary">
                {c.bundleName} · {c.memberCount} student{c.memberCount === 1 ? '' : 's'} ·{' '}
                {c.start_date} to {c.end_date}
              </p>
            </button>
            <select
              value={c.status}
              onChange={(e) => updateStatus(c, e.target.value as CohortStatus)}
              className="rounded-lg border border-border bg-background px-2.5 py-1.5 text-sm capitalize text-text"
            >
              {statuses.map((s) => (
                <option key={s} value={s}>
                  {s}
                </option>
              ))}
            </select>
          </div>
        ))}
        {cohorts.length === 0 && (
          <p className="py-10 text-center text-text-secondary">No cohorts yet.</p>
        )}
      </div>
    </div>
  )
}

function CohortDetail({ cohortId, onBack }: { cohortId: string; onBack: () => void }) {
  const [cohort, setCohort] = useState<Cohort | null>(null)
  const [members, setMembers] = useState<(Membership & { student: Profile | undefined })[]>([])
  const [candidates, setCandidates] = useState<Profile[]>([])
  const [loading, setLoading] = useState(true)
  const [addingId, setAddingId] = useState('')
  const [lateDecision, setLateDecision] = useState<LateJoinDecision>('allow')
  const [lateFee, setLateFee] = useState('')

  async function load() {
    setLoading(true)
    const { data: cohortRow } = await supabase.from('cohorts').select('*').eq('id', cohortId).maybeSingle()
    setCohort(cohortRow)
    if (!cohortRow) {
      setLoading(false)
      return
    }
    const [{ data: memberRows }, { data: profiles }] = await Promise.all([
      supabase.from('cohort_memberships').select('*').eq('cohort_id', cohortId),
      supabase
        .from('profiles')
        .select('*')
        .eq('assigned_bundle_id', cohortRow.bundle_id)
        .eq('approval_status', 'approved'),
    ])
    setMembers(
      (memberRows ?? []).map((m) => ({ ...m, student: profiles?.find((p) => p.id === m.student_id) })),
    )
    setCandidates((profiles ?? []).filter((p) => !memberRows?.some((m) => m.student_id === p.id)))
    setLoading(false)
  }

  useEffect(() => {
    load()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [cohortId])

  const isLate = cohort ? new Date(cohort.start_date) < new Date() : false

  async function addMember() {
    if (!cohort || !addingId) return
    await supabase.from('cohort_memberships').insert({
      student_id: addingId,
      cohort_id: cohort.id,
      bundle_id: cohort.bundle_id,
      is_late_join: isLate,
      late_join_decision: isLate ? lateDecision : null,
      late_fee: isLate && lateDecision === 'allow_with_fee' && lateFee ? Number(lateFee) : null,
    })
    setAddingId('')
    setLateFee('')
    await load()
  }

  async function removeMember(membershipId: string) {
    if (!confirm('Remove this student from the cohort?')) return
    await supabase.from('cohort_memberships').delete().eq('id', membershipId)
    await load()
  }

  if (loading || !cohort) {
    return (
      <div className="flex justify-center py-20 text-accent">
        <SpinnerIcon className="animate-spin" size={24} />
      </div>
    )
  }

  return (
    <div className="px-6 py-8">
      <button onClick={onBack} className="text-sm text-text-secondary hover:text-text">
        ← Back to cohorts
      </button>
      <h1 className="mt-3 font-heading text-2xl text-text">{cohort.name}</h1>
      <p className="mt-1 text-text-secondary">
        {cohort.start_date} to {cohort.end_date} ·{' '}
        {cohort.content_drop_mode === 'weekly' ? 'Weekly drip' : 'All at once'}
      </p>

      <h2 className="mt-8 font-heading text-lg text-text">Members ({members.length})</h2>
      <div className="mt-3 flex flex-col gap-2">
        {members.map((m) => (
          <div
            key={m.id}
            className="flex items-center justify-between rounded-xl border border-border bg-surface px-4 py-3"
          >
            <div>
              <p className="text-text">{m.student?.full_name ?? m.student_id}</p>
              {m.is_late_join && (
                <p className="text-xs text-accent">
                  Late join: {m.late_join_decision?.replace('_', ' ')}
                  {m.late_fee ? ` (${formatPrice(m.late_fee, 'NGN')})` : ''}
                </p>
              )}
            </div>
            <button
              onClick={() => removeMember(m.id)}
              className="text-sm text-red-400 hover:underline"
            >
              Remove
            </button>
          </div>
        ))}
        {members.length === 0 && <p className="text-text-secondary">No members yet.</p>}
      </div>

      <h2 className="mt-8 font-heading text-lg text-text">Add a student</h2>
      <div className="mt-3 flex flex-col gap-3 rounded-xl border border-border bg-surface p-4">
        <select
          value={addingId}
          onChange={(e) => setAddingId(e.target.value)}
          className="rounded-lg border border-border bg-background px-3 py-2 text-text"
        >
          <option value="">Select a student on this bundle</option>
          {candidates.map((c) => (
            <option key={c.id} value={c.id}>
              {c.full_name} ({c.email})
            </option>
          ))}
        </select>
        {isLate && (
          <div className="flex flex-wrap items-center gap-3">
            <span className="text-sm text-text-secondary">This cohort already started:</span>
            <select
              value={lateDecision}
              onChange={(e) => setLateDecision(e.target.value as LateJoinDecision)}
              className="rounded-lg border border-border bg-background px-2.5 py-1.5 text-sm text-text"
            >
              {lateDecisions.map((d) => (
                <option key={d} value={d}>
                  {d.replace('_', ' ')}
                </option>
              ))}
            </select>
            {lateDecision === 'allow_with_fee' && (
              <input
                type="number"
                value={lateFee}
                onChange={(e) => setLateFee(e.target.value)}
                placeholder="Fee amount"
                className="w-32 rounded-lg border border-border bg-background px-2.5 py-1.5 text-sm text-text"
              />
            )}
          </div>
        )}
        <button
          onClick={addMember}
          disabled={!addingId}
          className="w-fit rounded-lg bg-accent px-4 py-2 text-sm font-medium text-background hover:opacity-90 disabled:opacity-50"
        >
          Add to cohort
        </button>
      </div>
    </div>
  )
}
