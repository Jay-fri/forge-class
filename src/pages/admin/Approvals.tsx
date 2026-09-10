import { useEffect, useState } from 'react'
import { supabase } from '../../lib/supabase'
import { formatPrice, useActiveBundles } from '../../lib/bundles'
import type { ApprovalStatus, Database } from '../../lib/database.types'
import { SpinnerIcon } from '../../components/icons'

type Cohort = Database['public']['Tables']['cohorts']['Row']

interface PendingProfile {
  id: string
  full_name: string | null
  email: string
  approval_status: ApprovalStatus
  assigned_bundle_id: string | null
  created_at: string
  bundles: { name: string; price: number; currency: string; whatsapp_group_link: string | null } | null
}

const tabs: { label: string; value: ApprovalStatus }[] = [
  { label: 'Pending', value: 'pending' },
  { label: 'Approved', value: 'approved' },
  { label: 'Rejected', value: 'rejected' },
]

export function Approvals() {
  const { bundles, loading: bundlesLoading } = useActiveBundles()
  const [tab, setTab] = useState<ApprovalStatus>('pending')
  const [students, setStudents] = useState<PendingProfile[]>([])
  const [loading, setLoading] = useState(true)
  const [busyId, setBusyId] = useState<string | null>(null)
  const [copiedId, setCopiedId] = useState<string | null>(null)
  const [selectedBundle, setSelectedBundle] = useState<Record<string, string>>({})
  const [selectedCohort, setSelectedCohort] = useState<Record<string, string>>({})
  const [selectedIds, setSelectedIds] = useState<Set<string>>(new Set())
  const [cohorts, setCohorts] = useState<Cohort[]>([])
  const [actionError, setActionError] = useState<string | null>(null)
  const [bulkBusy, setBulkBusy] = useState(false)

  async function load() {
    setLoading(true)
    const [{ data }, { data: cohortRows }] = await Promise.all([
      supabase
        .from('profiles')
        .select(
          'id, full_name, email, approval_status, assigned_bundle_id, created_at, bundles(name, price, currency, whatsapp_group_link)',
        )
        .eq('role', 'student')
        .eq('approval_status', tab)
        .order('created_at', { ascending: false })
        .returns<PendingProfile[]>(),
      supabase.from('cohorts').select('*').neq('status', 'completed'),
    ])
    setStudents(data ?? [])
    setCohorts(cohortRows ?? [])
    setSelectedIds(new Set())
    setLoading(false)
  }

  useEffect(() => {
    load()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tab])

  async function approve(student: PendingProfile) {
    setBusyId(student.id)
    setActionError(null)
    const bundleId = selectedBundle[student.id] ?? student.assigned_bundle_id
    const { error } = await supabase
      .from('profiles')
      .update({
        approval_status: 'approved',
        assigned_bundle_id: bundleId,
        whatsapp_group_invited_at: new Date().toISOString(),
      })
      .eq('id', student.id)
    if (error) {
      setActionError(error.message)
      setBusyId(null)
      return
    }
    const cohortId = selectedCohort[student.id]
    if (cohortId && bundleId) {
      const cohort = cohorts.find((c) => c.id === cohortId)
      const isLate = cohort ? new Date(cohort.start_date) < new Date() : false
      await supabase.from('cohort_memberships').insert({
        student_id: student.id,
        cohort_id: cohortId,
        bundle_id: bundleId,
        is_late_join: isLate,
        late_join_decision: isLate ? 'allow' : null,
      })
    }
    setBusyId(null)
    load()
  }

  async function bulkApprove() {
    setBulkBusy(true)
    setActionError(null)
    for (const id of selectedIds) {
      const student = students.find((s) => s.id === id)
      if (student) await approve(student)
    }
    setBulkBusy(false)
  }

  function toggleSelected(id: string) {
    setSelectedIds((prev) => {
      const next = new Set(prev)
      if (next.has(id)) next.delete(id)
      else next.add(id)
      return next
    })
  }

  async function reject(student: PendingProfile) {
    setBusyId(student.id)
    setActionError(null)
    const { error } = await supabase
      .from('profiles')
      .update({ approval_status: 'rejected' })
      .eq('id', student.id)
    if (error) setActionError(error.message)
    setBusyId(null)
    load()
  }

  function copyInviteLink(student: PendingProfile) {
    const link = student.bundles?.whatsapp_group_link
    if (!link) return
    navigator.clipboard.writeText(link)
    setCopiedId(student.id)
    setTimeout(() => setCopiedId(null), 2000)
  }

  return (
    <div className="px-6 py-8">
      <h1 className="font-heading text-2xl text-text">Approvals</h1>
      <p className="mt-1 text-text-secondary">
        Approve once payment is confirmed via WhatsApp. This unlocks their
        bundle and hands you the group invite link to send manually.
      </p>

      {actionError && (
        <p className="mt-4 rounded-lg border border-red-400/30 bg-red-400/10 px-3 py-2 text-sm text-red-400">
          {actionError}
        </p>
      )}

      <div className="mt-6 flex gap-1 border-b border-border">
        {tabs.map((t) => (
          <button
            key={t.value}
            onClick={() => setTab(t.value)}
            className={`px-4 py-2 text-sm transition-colors ${
              tab === t.value
                ? 'border-b-2 border-accent text-text'
                : 'text-text-secondary hover:text-text'
            }`}
          >
            {t.label}
          </button>
        ))}
      </div>

      {tab === 'pending' && selectedIds.size > 0 && (
        <div className="mt-4 flex items-center gap-3 rounded-lg border border-accent/30 bg-accent/5 px-4 py-2.5">
          <span className="text-sm text-text">{selectedIds.size} selected</span>
          <button
            onClick={bulkApprove}
            disabled={bulkBusy}
            className="rounded-lg bg-accent px-3 py-1.5 text-sm font-medium text-background hover:opacity-90 disabled:opacity-50"
          >
            {bulkBusy ? 'Approving…' : 'Approve selected'}
          </button>
        </div>
      )}

      <div className="mt-6 flex flex-col gap-3">
        {(loading || bundlesLoading) && (
          <div className="flex justify-center py-10 text-accent">
            <SpinnerIcon className="animate-spin" size={24} />
          </div>
        )}

        {!loading && !bundlesLoading && students.length === 0 && (
          <p className="py-10 text-center text-text-secondary">
            No {tab} students right now.
          </p>
        )}

        {!loading && !bundlesLoading && students.map((s) => {
          const bundleId = selectedBundle[s.id] ?? s.assigned_bundle_id ?? ''
          const availableCohorts = cohorts.filter((c) => c.bundle_id === bundleId)
          return (
          <div
            key={s.id}
            className="flex flex-col gap-3 rounded-xl border border-border bg-surface p-4 sm:flex-row sm:items-center sm:justify-between"
          >
            <div className="flex items-start gap-3">
              {tab === 'pending' && (
                <input
                  type="checkbox"
                  checked={selectedIds.has(s.id)}
                  onChange={() => toggleSelected(s.id)}
                  className="mt-1.5"
                />
              )}
              <div>
                <p className="font-medium text-text">{s.full_name ?? 'Unnamed'}</p>
                <p className="text-sm text-text-secondary">{s.email}</p>
                <p className="mt-1 text-xs text-text-secondary">
                  Signed up {new Date(s.created_at).toLocaleDateString()}
                </p>
              </div>
            </div>

            <div className="flex flex-wrap items-center gap-2">
              <select
                value={bundleId}
                onChange={(e) =>
                  setSelectedBundle((prev) => ({ ...prev, [s.id]: e.target.value }))
                }
                className="rounded-lg border border-border bg-background px-2.5 py-1.5 text-sm text-text"
              >
                <option value="">No bundle</option>
                {bundles.map((b) => (
                  <option key={b.id} value={b.id}>
                    {b.name}: {formatPrice(b.price, b.currency)}
                  </option>
                ))}
              </select>

              {tab === 'pending' && availableCohorts.length > 0 && (
                <select
                  value={selectedCohort[s.id] ?? ''}
                  onChange={(e) =>
                    setSelectedCohort((prev) => ({ ...prev, [s.id]: e.target.value }))
                  }
                  className="rounded-lg border border-border bg-background px-2.5 py-1.5 text-sm text-text"
                >
                  <option value="">No cohort</option>
                  {availableCohorts.map((c) => (
                    <option key={c.id} value={c.id}>
                      {c.name}
                    </option>
                  ))}
                </select>
              )}

              {tab === 'pending' && (
                <>
                  <button
                    disabled={busyId === s.id}
                    onClick={() => approve(s)}
                    className="rounded-lg bg-accent px-3 py-1.5 text-sm font-medium text-background hover:opacity-90 disabled:opacity-50"
                  >
                    Approve
                  </button>
                  <button
                    disabled={busyId === s.id}
                    onClick={() => reject(s)}
                    className="rounded-lg border border-border px-3 py-1.5 text-sm text-text-secondary hover:bg-background disabled:opacity-50"
                  >
                    Reject
                  </button>
                </>
              )}

              {tab === 'approved' && (
                <button
                  onClick={() => copyInviteLink(s)}
                  disabled={!s.bundles?.whatsapp_group_link}
                  className="rounded-lg border border-border px-3 py-1.5 text-sm text-text-secondary hover:bg-background disabled:opacity-40"
                  title={
                    s.bundles?.whatsapp_group_link
                      ? 'Copy WhatsApp group invite link'
                      : 'No group link set for this bundle yet'
                  }
                >
                  {copiedId === s.id ? 'Copied!' : 'Copy group invite'}
                </button>
              )}
            </div>
          </div>
          )
        })}
      </div>
    </div>
  )
}
