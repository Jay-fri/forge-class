import { useEffect, useState } from 'react'
import { Link, Navigate, useParams } from 'react-router-dom'
import { supabase } from '../../../lib/supabase'
import { slugify } from '../../../lib/slug'
import type { Database, TrackLevel } from '../../../lib/database.types'
import { Breadcrumbs } from '../../../components/admin/Breadcrumbs'
import { SpinnerIcon } from '../../../components/icons'

type Track = Database['public']['Tables']['tracks']['Row']
type Bundle = Database['public']['Tables']['bundles']['Row']
type Module = Database['public']['Tables']['modules']['Row']

const levels: TrackLevel[] = ['beginner', 'intermediate', 'advanced']

export function TrackDetail() {
  const params = useParams<{ trackSlug: string }>()
  const trackSlug = params.trackSlug!
  const [track, setTrack] = useState<Track | null>(null)
  const [notFound, setNotFound] = useState(false)
  const [bundles, setBundles] = useState<Bundle[]>([])
  const [linkedBundleIds, setLinkedBundleIds] = useState<string[]>([])
  const [modules, setModules] = useState<(Module & { lessonCount: number })[]>([])
  const [loading, setLoading] = useState(true)

  const [editingTrack, setEditingTrack] = useState(false)
  const [draft, setDraft] = useState<Partial<Track>>({})
  const [draftBundleIds, setDraftBundleIds] = useState<string[]>([])
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const [creatingModule, setCreatingModule] = useState(false)
  const [moduleDraft, setModuleDraft] = useState({ name: '', slug: '' })

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

    const [{ data: bundleRows }, { data: linkRows }, { data: moduleRows }, { data: lessonRows }] =
      await Promise.all([
        supabase.from('bundles').select('*').order('price'),
        supabase.from('bundle_tracks').select('bundle_id').eq('track_id', trackRow.id),
        supabase.from('modules').select('*').eq('track_id', trackRow.id).order('order_index'),
        supabase.from('lessons').select('id, module_id'),
      ])

    setBundles(bundleRows ?? [])
    setLinkedBundleIds((linkRows ?? []).map((l) => l.bundle_id))
    setModules(
      (moduleRows ?? []).map((m) => ({
        ...m,
        lessonCount: (lessonRows ?? []).filter((l) => l.module_id === m.id).length,
      })),
    )
    setLoading(false)
  }

  useEffect(() => {
    load()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [trackSlug])

  function startEditTrack() {
    if (!track) return
    setDraft(track)
    setDraftBundleIds(linkedBundleIds)
    setEditingTrack(true)
    setError(null)
  }

  function toggleDraftBundle(id: string) {
    setDraftBundleIds((prev) =>
      prev.includes(id) ? prev.filter((b) => b !== id) : [...prev, id],
    )
  }

  async function saveTrack() {
    if (!track) return
    setSaving(true)
    setError(null)
    try {
      const { error: trackErr } = await supabase
        .from('tracks')
        .update({
          name: draft.name,
          slug: draft.slug,
          level: draft.level,
          description: draft.description,
        })
        .eq('id', track.id)
      if (trackErr) throw trackErr

      const toAdd = draftBundleIds.filter((id) => !linkedBundleIds.includes(id))
      const toRemove = linkedBundleIds.filter((id) => !draftBundleIds.includes(id))
      if (toAdd.length) {
        const { error: addErr } = await supabase
          .from('bundle_tracks')
          .insert(toAdd.map((bundle_id) => ({ bundle_id, track_id: track.id })))
        if (addErr) throw addErr
      }
      if (toRemove.length) {
        const { error: removeErr } = await supabase
          .from('bundle_tracks')
          .delete()
          .eq('track_id', track.id)
          .in('bundle_id', toRemove)
        if (removeErr) throw removeErr
      }

      setEditingTrack(false)
      await load()
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to save track.')
    } finally {
      setSaving(false)
    }
  }

  async function createModule() {
    if (!track) return
    setSaving(true)
    setError(null)
    try {
      const { error: createErr } = await supabase.from('modules').insert({
        track_id: track.id,
        name: moduleDraft.name,
        slug: moduleDraft.slug || slugify(moduleDraft.name),
        order_index: modules.length,
      })
      if (createErr) throw createErr
      setModuleDraft({ name: '', slug: '' })
      setCreatingModule(false)
      await load()
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to create module.')
    } finally {
      setSaving(false)
    }
  }

  if (notFound) return <Navigate to="/admin/curriculum" replace />

  if (loading || !track) {
    return (
      <div className="flex justify-center py-20 text-accent">
        <SpinnerIcon className="animate-spin" size={24} />
      </div>
    )
  }

  return (
    <div className="px-6 py-8">
      <Breadcrumbs
        items={[{ label: 'Curriculum', to: '/admin/curriculum' }, { label: track.name }]}
      />

      {editingTrack ? (
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

          <label className="flex flex-col gap-1 text-sm text-text-secondary">
            Description
            <textarea
              value={draft.description ?? ''}
              onChange={(e) => setDraft((d) => ({ ...d, description: e.target.value }))}
              rows={2}
              className="rounded-lg border border-border bg-background px-3 py-2 text-text"
            />
          </label>

          <label className="flex flex-col gap-1 text-sm text-text-secondary">
            Level
            <select
              value={draft.level}
              onChange={(e) => setDraft((d) => ({ ...d, level: e.target.value as TrackLevel }))}
              className="w-fit rounded-lg border border-border bg-background px-3 py-2 text-text"
            >
              {levels.map((l) => (
                <option key={l} value={l}>
                  {l}
                </option>
              ))}
            </select>
          </label>

          <div className="flex flex-col gap-1.5 text-sm text-text-secondary">
            Bundles this track belongs to
            <div className="flex flex-wrap gap-2">
              {bundles.map((b) => (
                <button
                  key={b.id}
                  type="button"
                  onClick={() => toggleDraftBundle(b.id)}
                  className={`rounded-full border px-3 py-1 text-xs transition-colors ${
                    draftBundleIds.includes(b.id)
                      ? 'border-accent bg-accent/10 text-accent'
                      : 'border-border text-text-secondary hover:border-accent/40'
                  }`}
                >
                  {b.name}
                </button>
              ))}
            </div>
          </div>

          {error && <p className="text-sm text-red-400">{error}</p>}

          <div className="flex gap-2">
            <button
              onClick={saveTrack}
              disabled={saving}
              className="rounded-lg bg-accent px-4 py-2 text-sm font-medium text-background hover:opacity-90 disabled:opacity-60"
            >
              {saving ? 'Saving…' : 'Save'}
            </button>
            <button
              onClick={() => setEditingTrack(false)}
              className="rounded-lg border border-border px-4 py-2 text-sm text-text-secondary hover:bg-background"
            >
              Cancel
            </button>
          </div>
        </div>
      ) : (
        <div className="flex items-start justify-between">
          <div>
            <h1 className="font-heading text-2xl text-text">{track.name}</h1>
            {track.description && (
              <p className="mt-1 max-w-xl text-text-secondary">{track.description}</p>
            )}
            <p className="mt-1 text-xs capitalize text-text-secondary">{track.level}</p>
          </div>
          <button
            onClick={startEditTrack}
            className="rounded-lg border border-border px-3 py-1.5 text-sm text-text-secondary hover:bg-surface"
          >
            Edit track
          </button>
        </div>
      )}

      <div className="mt-8 flex items-center justify-between">
        <h2 className="font-heading text-lg text-text">Modules</h2>
        <button
          type="button"
          onClick={() => setCreatingModule((c) => !c)}
          className="rounded-lg bg-accent px-3.5 py-1.5 text-sm font-medium text-background hover:opacity-90"
        >
          {creatingModule ? 'Cancel' : 'New module'}
        </button>
      </div>

      {creatingModule && (
        <div className="mt-3 flex flex-col gap-3 rounded-xl border border-border bg-surface p-4">
          <div className="grid gap-3 sm:grid-cols-2">
            <label className="flex flex-col gap-1 text-sm text-text-secondary">
              Name
              <input
                value={moduleDraft.name}
                onChange={(e) =>
                  setModuleDraft((d) => ({
                    ...d,
                    name: e.target.value,
                    slug: d.slug || slugify(e.target.value),
                  }))
                }
                className="rounded-lg border border-border bg-background px-3 py-2 text-text"
              />
            </label>
            <label className="flex flex-col gap-1 text-sm text-text-secondary">
              Slug
              <input
                value={moduleDraft.slug}
                onChange={(e) =>
                  setModuleDraft((d) => ({ ...d, slug: slugify(e.target.value) }))
                }
                className="rounded-lg border border-border bg-background px-3 py-2 text-text"
              />
            </label>
          </div>
          {error && <p className="text-sm text-red-400">{error}</p>}
          <button
            onClick={createModule}
            disabled={saving || !moduleDraft.name}
            className="w-fit rounded-lg bg-accent px-4 py-2 text-sm font-medium text-background hover:opacity-90 disabled:opacity-50"
          >
            {saving ? 'Creating…' : 'Create module'}
          </button>
        </div>
      )}

      <div className="mt-3 flex flex-col gap-3">
        {modules.length === 0 && (
          <p className="py-8 text-center text-text-secondary">No modules yet.</p>
        )}
        {modules.map((m) => (
          <Link
            key={m.id}
            to={`/admin/curriculum/${track.slug}/${m.slug}`}
            className="flex items-center justify-between rounded-xl border border-border bg-surface p-4 transition-colors hover:border-accent/40"
          >
            <p className="font-medium text-text">{m.name}</p>
            <p className="text-sm text-text-secondary">
              {m.lessonCount} lesson{m.lessonCount === 1 ? '' : 's'}
            </p>
          </Link>
        ))}
      </div>
    </div>
  )
}
