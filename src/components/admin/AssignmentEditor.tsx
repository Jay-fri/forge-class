import { useEffect, useState } from 'react'
import { supabase } from '../../lib/supabase'
import type { Database } from '../../lib/database.types'
import { Markdown } from '../content/Markdown'

type Assignment = Database['public']['Tables']['assignments']['Row']

export function AssignmentEditor({
  parentType,
  parentId,
}: {
  parentType: 'lesson' | 'module'
  parentId: string
}) {
  const column = parentType === 'lesson' ? 'lesson_id' : 'module_id'
  const [assignment, setAssignment] = useState<Assignment | null>(null)
  const [loading, setLoading] = useState(true)
  const [editing, setEditing] = useState(false)
  const [draft, setDraft] = useState({ title: '', spec: '', starterFilesText: '', starter_template: 'vanilla' })
  const [filesError, setFilesError] = useState<string | null>(null)
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState<string | null>(null)

  async function load() {
    const { data } = await supabase
      .from('assignments')
      .select('*')
      .eq(column, parentId)
      .maybeSingle()
    setAssignment(data)
    setLoading(false)
  }

  useEffect(() => {
    load()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [parentId])

  function startCreate() {
    setDraft({ title: '', spec: '', starterFilesText: '', starter_template: 'vanilla' })
    setEditing(true)
    setError(null)
  }

  function startEdit() {
    if (!assignment) return
    setDraft({
      title: assignment.title,
      spec: assignment.spec,
      starterFilesText: assignment.starter_code
        ? JSON.stringify(assignment.starter_code, null, 2)
        : '',
      starter_template: assignment.starter_template ?? 'vanilla',
    })
    setEditing(true)
    setError(null)
  }

  async function save() {
    setSaving(true)
    setError(null)
    let starterCode: Record<string, string> | null = null
    if (draft.starterFilesText.trim()) {
      try {
        starterCode = JSON.parse(draft.starterFilesText)
        setFilesError(null)
      } catch {
        setFilesError('Invalid JSON, not saved until this is fixed.')
        setSaving(false)
        return
      }
    }
    try {
      if (assignment) {
        const { error: err } = await supabase
          .from('assignments')
          .update({
            title: draft.title,
            spec: draft.spec,
            starter_code: starterCode,
            starter_template: starterCode ? draft.starter_template : null,
          })
          .eq('id', assignment.id)
        if (err) throw err
      } else {
        const { error: err } = await supabase.from('assignments').insert({
          lesson_id: parentType === 'lesson' ? parentId : null,
          module_id: parentType === 'module' ? parentId : null,
          title: draft.title,
          spec: draft.spec,
          starter_code: starterCode,
          starter_template: starterCode ? draft.starter_template : null,
        })
        if (err) throw err
      }
      setEditing(false)
      await load()
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to save assignment.')
    } finally {
      setSaving(false)
    }
  }

  async function remove() {
    if (!assignment || !confirm('Delete this assignment? Student submissions will remain but lose their assignment.')) return
    await supabase.from('assignments').delete().eq('id', assignment.id)
    await load()
  }

  if (loading) return null

  return (
    <div>
      <div className="flex items-center justify-between">
        <h2 className="font-heading text-lg text-text">Assignment</h2>
        {!editing && !assignment && (
          <button
            type="button"
            onClick={startCreate}
            className="text-sm text-accent hover:underline"
          >
            + Add assignment
          </button>
        )}
      </div>

      {!editing && assignment && (
        <div className="mt-3 rounded-xl border border-border bg-surface p-4">
          <div className="flex items-center justify-between gap-3">
            <p className="min-w-0 truncate font-medium text-text">{assignment.title}</p>
            <div className="flex shrink-0 gap-2">
              <button
                onClick={startEdit}
                className="rounded-lg border border-border px-3 py-1 text-xs text-text-secondary hover:bg-background"
              >
                Edit
              </button>
              <button
                onClick={remove}
                className="rounded-lg border border-border px-3 py-1 text-xs text-red-400 hover:bg-background"
              >
                Delete
              </button>
            </div>
          </div>
          <div className="mt-2">
            <Markdown>{assignment.spec}</Markdown>
          </div>
        </div>
      )}

      {editing && (
        <div className="mt-3 flex flex-col gap-3 rounded-xl border border-border bg-surface p-4">
          <label className="flex flex-col gap-1 text-sm text-text-secondary">
            Title
            <input
              value={draft.title}
              onChange={(e) => setDraft((d) => ({ ...d, title: e.target.value }))}
              className="rounded-lg border border-border bg-background px-3 py-2 text-text"
            />
          </label>
          <label className="flex flex-col gap-1 text-sm text-text-secondary">
            Spec (Markdown)
            <textarea
              value={draft.spec}
              onChange={(e) => setDraft((d) => ({ ...d, spec: e.target.value }))}
              rows={8}
              className="rounded-lg border border-border bg-background px-3 py-2 font-mono text-sm text-text"
            />
          </label>
          <label className="flex flex-col gap-1 text-sm text-text-secondary">
            Starter code files (JSON, optional)
            <textarea
              value={draft.starterFilesText}
              onChange={(e) => setDraft((d) => ({ ...d, starterFilesText: e.target.value }))}
              rows={5}
              placeholder='{"/index.js": "// start here"}'
              className="rounded-lg border border-border bg-background px-3 py-2 font-mono text-xs text-text"
            />
          </label>
          {filesError && <p className="text-sm text-red-400">{filesError}</p>}
          {error && <p className="text-sm text-red-400">{error}</p>}
          <div className="flex gap-2">
            <button
              onClick={save}
              disabled={saving || !draft.title || !draft.spec}
              className="w-fit rounded-lg bg-accent px-4 py-2 text-sm font-medium text-background hover:opacity-90 disabled:opacity-50"
            >
              {saving ? 'Saving…' : 'Save'}
            </button>
            <button
              onClick={() => setEditing(false)}
              className="w-fit rounded-lg border border-border px-4 py-2 text-sm text-text-secondary hover:bg-background"
            >
              Cancel
            </button>
          </div>
        </div>
      )}
    </div>
  )
}
