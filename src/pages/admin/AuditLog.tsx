import { useEffect, useState } from 'react'
import { supabase } from '../../lib/supabase'
import type { Database } from '../../lib/database.types'
import { SpinnerIcon } from '../../components/icons'

type AuditEntry = Database['public']['Tables']['audit_log']['Row']
type Profile = Database['public']['Tables']['profiles']['Row']

interface AuditRow extends AuditEntry {
  actorName: string
}

const actionLabels: Record<string, string> = {
  approval_status_changed: 'Approval status changed',
  bundle_assignment_changed: 'Bundle assignment changed',
  bundle_created: 'Bundle created',
  bundle_updated: 'Bundle updated',
  bundle_deleted: 'Bundle deleted',
  content_created: 'Content created',
  content_updated: 'Content updated',
  content_deleted: 'Content deleted',
}

export function AuditLog() {
  const [entries, setEntries] = useState<AuditRow[]>([])
  const [loading, setLoading] = useState(true)
  const [filter, setFilter] = useState<string>('all')

  useEffect(() => {
    async function load() {
      const [{ data: logRows }, { data: profiles }] = await Promise.all([
        supabase.from('audit_log').select('*').order('created_at', { ascending: false }).limit(200),
        supabase.from('profiles').select('*'),
      ])
      setEntries(
        (logRows ?? []).map((e) => ({
          ...e,
          actorName:
            (profiles as Profile[] | null)?.find((p) => p.id === e.actor_id)?.full_name ?? 'System',
        })),
      )
      setLoading(false)
    }
    load()
  }, [])

  const entityTypes = [...new Set(entries.map((e) => e.entity_type))]
  const visible = filter === 'all' ? entries : entries.filter((e) => e.entity_type === filter)

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
          <h1 className="font-heading text-2xl text-text">Audit log</h1>
          <p className="mt-1 text-text-secondary">Every approval, bundle change, and content edit.</p>
        </div>
        <select
          value={filter}
          onChange={(e) => setFilter(e.target.value)}
          className="rounded-lg border border-border bg-surface px-3 py-2 text-sm capitalize text-text"
        >
          <option value="all">All types</option>
          {entityTypes.map((t) => (
            <option key={t} value={t}>
              {t}
            </option>
          ))}
        </select>
      </div>

      <div className="mt-6 flex flex-col gap-2">
        {visible.map((e) => (
          <div key={e.id} className="rounded-xl border border-border bg-surface px-4 py-3">
            <div className="flex items-center justify-between">
              <p className="text-text">{actionLabels[e.action] ?? e.action}</p>
              <p className="text-xs text-text-secondary">
                {new Date(e.created_at).toLocaleString()}
              </p>
            </div>
            <p className="mt-1 text-sm text-text-secondary">
              {e.actorName} · {e.entity_type}
              {e.detail && typeof e.detail === 'object' && (
                <>
                  {' '}
                  {Object.entries(e.detail)
                    .map(([k, v]) => `${k}: ${v}`)
                    .join(', ')}
                </>
              )}
            </p>
          </div>
        ))}
        {visible.length === 0 && (
          <p className="py-10 text-center text-text-secondary">No activity logged yet.</p>
        )}
      </div>
    </div>
  )
}
