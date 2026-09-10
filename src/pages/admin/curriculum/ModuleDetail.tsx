import { useEffect, useState } from 'react'
import { Link, Navigate, useParams } from 'react-router-dom'
import { supabase } from '../../../lib/supabase'
import { slugify } from '../../../lib/slug'
import type { Database } from '../../../lib/database.types'
import { Breadcrumbs } from '../../../components/admin/Breadcrumbs'
import { AssignmentEditor } from '../../../components/admin/AssignmentEditor'
import { SpinnerIcon } from '../../../components/icons'

type Track = Database['public']['Tables']['tracks']['Row']
type Module = Database['public']['Tables']['modules']['Row']
type Lesson = Database['public']['Tables']['lessons']['Row']

export function ModuleDetail() {
  const params = useParams<{ trackSlug: string; moduleSlug: string }>()
  const trackSlug = params.trackSlug!
  const moduleSlug = params.moduleSlug!
  const [track, setTrack] = useState<Track | null>(null)
  const [module, setModule] = useState<Module | null>(null)
  const [lessons, setLessons] = useState<(Lesson & { sectionCount: number })[]>([])
  const [notFound, setNotFound] = useState(false)
  const [loading, setLoading] = useState(true)

  const [editingModule, setEditingModule] = useState(false)
  const [draft, setDraft] = useState<Partial<Module>>({})
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const [creatingLesson, setCreatingLesson] = useState(false)
  const [lessonDraft, setLessonDraft] = useState({ title: '', slug: '', isFreePreview: false })

  async function load() {
    setLoading(true)
    const { data: trackRow } = await supabase
      .from('tracks')
      .select('*')
      .eq('slug', trackSlug)
      .maybeSingle()
    if (!trackRow) {
      setNotFound(true)
      setLoading(false)
      return
    }
    setTrack(trackRow)

    const { data: moduleRow } = await supabase
      .from('modules')
      .select('*')
      .eq('track_id', trackRow.id)
      .eq('slug', moduleSlug)
      .maybeSingle()
    if (!moduleRow) {
      setNotFound(true)
      setLoading(false)
      return
    }
    setModule(moduleRow)

    const [{ data: lessonRows }, { data: sectionRows }] = await Promise.all([
      supabase.from('lessons').select('*').eq('module_id', moduleRow.id).order('order_index'),
      supabase.from('sections').select('id, lesson_id'),
    ])
    setLessons(
      (lessonRows ?? []).map((l) => ({
        ...l,
        sectionCount: (sectionRows ?? []).filter((s) => s.lesson_id === l.id).length,
      })),
    )
    setLoading(false)
  }

  useEffect(() => {
    load()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [trackSlug, moduleSlug])

  function startEdit() {
    if (!module) return
    setDraft(module)
    setEditingModule(true)
    setError(null)
  }

  async function saveModule() {
    if (!module) return
    setSaving(true)
    setError(null)
    try {
      const { error: err } = await supabase
        .from('modules')
        .update({ name: draft.name, slug: draft.slug })
        .eq('id', module.id)
      if (err) throw err
      setEditingModule(false)
      await load()
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to save module.')
    } finally {
      setSaving(false)
    }
  }

  async function createLesson() {
    if (!module) return
    setSaving(true)
    setError(null)
    try {
      const { error: err } = await supabase.from('lessons').insert({
        module_id: module.id,
        title: lessonDraft.title,
        slug: lessonDraft.slug || slugify(lessonDraft.title),
        order_index: lessons.length,
        is_free_preview: lessonDraft.isFreePreview,
      })
      if (err) throw err
      setLessonDraft({ title: '', slug: '', isFreePreview: false })
      setCreatingLesson(false)
      await load()
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to create lesson.')
    } finally {
      setSaving(false)
    }
  }

  if (notFound) return <Navigate to="/admin/curriculum" replace />

  if (loading || !track || !module) {
    return (
      <div className="flex justify-center py-20 text-accent">
        <SpinnerIcon className="animate-spin" size={24} />
      </div>
    )
  }

  return (
    <div className="px-6 py-8">
      <Breadcrumbs
        items={[
          { label: 'Curriculum', to: '/admin/curriculum' },
          { label: track.name, to: `/admin/curriculum/${track.slug}` },
          { label: module.name },
        ]}
      />

      {editingModule ? (
        <div className="flex flex-col gap-3 rounded-xl border border-border bg-surface p-4">
          <div className="grid gap-3 sm:grid-cols-2">
            <label className="flex flex-col gap-1 text-sm text-text-secondary">
              Name
              <input
                value={draft.name ?? ''}
                onChange={(e) => setDraft((d) => ({ ...d, name: e.target.value }))}
                className="rounded-lg border border-border bg-background px-3 py-2 text-text"
              />
            </label>
            <label className="flex flex-col gap-1 text-sm text-text-secondary">
              Slug
              <input
                value={draft.slug ?? ''}
                onChange={(e) => setDraft((d) => ({ ...d, slug: slugify(e.target.value) }))}
                className="rounded-lg border border-border bg-background px-3 py-2 text-text"
              />
            </label>
          </div>
          {error && <p className="text-sm text-red-400">{error}</p>}
          <div className="flex gap-2">
            <button
              onClick={saveModule}
              disabled={saving}
              className="rounded-lg bg-accent px-4 py-2 text-sm font-medium text-background hover:opacity-90 disabled:opacity-60"
            >
              {saving ? 'Saving…' : 'Save'}
            </button>
            <button
              onClick={() => setEditingModule(false)}
              className="rounded-lg border border-border px-4 py-2 text-sm text-text-secondary hover:bg-background"
            >
              Cancel
            </button>
          </div>
        </div>
      ) : (
        <div className="flex items-start justify-between">
          <h1 className="font-heading text-2xl text-text">{module.name}</h1>
          <button
            onClick={startEdit}
            className="rounded-lg border border-border px-3 py-1.5 text-sm text-text-secondary hover:bg-surface"
          >
            Edit module
          </button>
        </div>
      )}

      <div className="mt-8 flex items-center justify-between">
        <h2 className="font-heading text-lg text-text">Lessons</h2>
        <button
          type="button"
          onClick={() => setCreatingLesson((c) => !c)}
          className="rounded-lg bg-accent px-3.5 py-1.5 text-sm font-medium text-background hover:opacity-90"
        >
          {creatingLesson ? 'Cancel' : 'New lesson'}
        </button>
      </div>

      {creatingLesson && (
        <div className="mt-3 flex flex-col gap-3 rounded-xl border border-border bg-surface p-4">
          <div className="grid gap-3 sm:grid-cols-2">
            <label className="flex flex-col gap-1 text-sm text-text-secondary">
              Title
              <input
                value={lessonDraft.title}
                onChange={(e) =>
                  setLessonDraft((d) => ({
                    ...d,
                    title: e.target.value,
                    slug: d.slug || slugify(e.target.value),
                  }))
                }
                className="rounded-lg border border-border bg-background px-3 py-2 text-text"
              />
            </label>
            <label className="flex flex-col gap-1 text-sm text-text-secondary">
              Slug
              <input
                value={lessonDraft.slug}
                onChange={(e) =>
                  setLessonDraft((d) => ({ ...d, slug: slugify(e.target.value) }))
                }
                className="rounded-lg border border-border bg-background px-3 py-2 text-text"
              />
            </label>
          </div>
          <label className="flex items-center gap-2 text-sm text-text-secondary">
            <input
              type="checkbox"
              checked={lessonDraft.isFreePreview}
              onChange={(e) =>
                setLessonDraft((d) => ({ ...d, isFreePreview: e.target.checked }))
              }
            />
            Free preview (visible to pending/unapproved students)
          </label>
          {error && <p className="text-sm text-red-400">{error}</p>}
          <button
            onClick={createLesson}
            disabled={saving || !lessonDraft.title}
            className="w-fit rounded-lg bg-accent px-4 py-2 text-sm font-medium text-background hover:opacity-90 disabled:opacity-50"
          >
            {saving ? 'Creating…' : 'Create lesson'}
          </button>
        </div>
      )}

      <div className="mt-3 flex flex-col gap-3">
        {lessons.length === 0 && (
          <p className="py-8 text-center text-text-secondary">No lessons yet.</p>
        )}
        {lessons.map((l) => (
          <Link
            key={l.id}
            to={`/admin/curriculum/${track.slug}/${module.slug}/${l.slug}`}
            className="flex items-center justify-between rounded-xl border border-border bg-surface p-4 transition-colors hover:border-accent/40"
          >
            <p className="font-medium text-text">{l.title}</p>
            <div className="flex items-center gap-2">
              {l.is_free_preview && (
                <span className="rounded-full border border-success/40 px-2 py-0.5 text-xs text-success">
                  Free preview
                </span>
              )}
              <p className="text-sm text-text-secondary">
                {l.sectionCount} section{l.sectionCount === 1 ? '' : 's'}
              </p>
            </div>
          </Link>
        ))}
      </div>

      <div className="mt-8">
        <AssignmentEditor parentType="module" parentId={module.id} />
      </div>
    </div>
  )
}
