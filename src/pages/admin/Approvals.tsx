import { useEffect, useState } from 'react'
import { supabase } from '../../lib/supabase'
import { formatPrice, useActiveBundles } from '../../lib/bundles'
import type { ApprovalStatus } from '../../lib/database.types'
import { SpinnerIcon } from '../../components/icons'

interface PendingProfile {
  id: string
  full_name: string | null
  email: string
  approval_status: ApprovalStatus
  created_at: string
}

interface StudentBundleRow {
  student_id: string
  bundle_id: string
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
  const [studentBundles, setStudentBundles] = useState<StudentBundleRow[]>([])
  const [loading, setLoading] = useState(true)
  const [busyId, setBusyId] = useState<string | null>(null)
  const [copiedKey, setCopiedKey] = useState<string | null>(null)
  const [selectedBundles, setSelectedBundles] = useState<Record<string, string[]>>({})
  const [selectedIds, setSelectedIds] = useState<Set<string>>(new Set())
  const [actionError, setActionError] = useState<string | null>(null)
  const [bulkBusy, setBulkBusy] = useState(false)

  async function load() {
    setLoading(true)
    const { data } = await supabase
      .from('profiles')
      .select('id, full_name, email, approval_status, created_at')
      .eq('role', 'student')
      .eq('approval_status', tab)
      .order('created_at', { ascending: false })

    const studentIds = (data ?? []).map((s) => s.id)
    const { data: sbRows } = studentIds.length
      ? await supabase
          .from('student_bundles')
          .select('student_id, bundle_id, bundles(name, price, currency, whatsapp_group_link)')
          .in('student_id', studentIds)
      : { data: [] as StudentBundleRow[] }

    setStudents(data ?? [])
    setStudentBundles((sbRows ?? []) as unknown as StudentBundleRow[])
    setSelectedBundles(
      Object.fromEntries(
        (data ?? []).map((s) => [
          s.id,
          (sbRows ?? []).filter((sb) => sb.student_id === s.id).map((sb) => sb.bundle_id),
        ]),
      ),
    )
    setSelectedIds(new Set())
    setLoading(false)
  }

  useEffect(() => {
    load()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tab])

  function toggleBundleForStudent(studentId: string, bundleId: string) {
    setSelectedBundles((prev) => {
      const current = prev[studentId] ?? []
      const next = current.includes(bundleId)
        ? current.filter((id) => id !== bundleId)
        : [...current, bundleId]
      return { ...prev, [studentId]: next }
    })
  }

  async function approve(student: PendingProfile) {
    setBusyId(student.id)
    setActionError(null)
    const bundleIds = selectedBundles[student.id] ?? []
    const { error } = await supabase
      .from('profiles')
      .update({
        approval_status: 'approved',
        whatsapp_group_invited_at: new Date().toISOString(),
      })
      .eq('id', student.id)
    if (error) {
      setActionError(error.message)
      setBusyId(null)
      return
    }
    if (bundleIds.length > 0) {
      const { error: bundleErr } = await supabase
        .from('student_bundles')
        .upsert(
          bundleIds.map((bundle_id) => ({ student_id: student.id, bundle_id })),
          { onConflict: 'student_id,bundle_id' },
        )
      if (bundleErr) setActionError(bundleErr.message)
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

  function copyInviteLink(studentId: string, bundleId: string, link: string | null) {
    if (!link) return
    navigator.clipboard.writeText(link)
    setCopiedKey(`${studentId}:${bundleId}`)
    setTimeout(() => setCopiedKey(null), 2000)
  }

  return (
    <div className="px-6 py-8">
      <h1 className="font-heading text-2xl text-text">Approvals</h1>
      <p className="mt-1 text-text-secondary">
        Approve once payment is confirmed via WhatsApp. This unlocks their
        bundles and hands you each group invite link to send manually.
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
          const chosenBundleIds = selectedBundles[s.id] ?? []
          const enrolledBundles = studentBundles.filter((sb) => sb.student_id === s.id)
          return (
          <div
            key={s.id}
            className="flex flex-col gap-3 rounded-xl border border-border bg-surface p-4"
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
              <div className="min-w-0">
                <p className="truncate font-medium text-text">{s.full_name ?? 'Unnamed'}</p>
                <p className="truncate text-sm text-text-secondary">{s.email}</p>
                <p className="mt-1 text-xs text-text-secondary">
                  Signed up {new Date(s.created_at).toLocaleDateString()}
                </p>
              </div>
            </div>

            {tab === 'pending' && (
              <div>
                <p className="mb-1.5 text-xs uppercase tracking-wide text-text-secondary/70">
                  Bundles to grant
                </p>
                <div className="flex flex-wrap gap-2">
                  {bundles.map((b) => (
                    <button
                      key={b.id}
                      type="button"
                      onClick={() => toggleBundleForStudent(s.id, b.id)}
                      className={`rounded-full border px-3 py-1.5 text-sm transition-colors ${
                        chosenBundleIds.includes(b.id)
                          ? 'border-accent bg-accent/10 text-accent'
                          : 'border-border text-text-secondary hover:border-accent/40'
                      }`}
                    >
                      {b.name}: {formatPrice(b.price, b.currency)}
                    </button>
                  ))}
                </div>
              </div>
            )}

            {tab === 'approved' && (
              <div className="flex flex-wrap gap-2">
                {enrolledBundles.length === 0 && (
                  <span className="text-sm text-text-secondary">No bundles granted</span>
                )}
                {enrolledBundles.map((sb) => (
                  <span
                    key={sb.bundle_id}
                    className="flex items-center gap-2 rounded-full border border-border bg-background px-3 py-1.5 text-sm text-text-secondary"
                  >
                    {sb.bundles?.name}
                    <button
                      type="button"
                      onClick={() => copyInviteLink(s.id, sb.bundle_id, sb.bundles?.whatsapp_group_link ?? null)}
                      disabled={!sb.bundles?.whatsapp_group_link}
                      className="text-accent hover:underline disabled:cursor-not-allowed disabled:text-text-secondary disabled:no-underline"
                      title={
                        sb.bundles?.whatsapp_group_link
                          ? 'Copy WhatsApp group invite link'
                          : 'No group link set for this bundle yet'
                      }
                    >
                      {copiedKey === `${s.id}:${sb.bundle_id}` ? 'Copied!' : 'Copy invite'}
                    </button>
                  </span>
                ))}
              </div>
            )}

            {tab === 'pending' && (
              <div className="flex gap-2">
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
              </div>
            )}
          </div>
          )
        })}
      </div>
    </div>
  )
}
