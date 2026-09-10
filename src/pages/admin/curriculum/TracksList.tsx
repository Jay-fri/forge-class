import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { supabase } from '../../../lib/supabase'
import { slugify } from '../../../lib/slug'
import type { Database, TrackLevel } from '../../../lib/database.types'
import { Breadcrumbs } from '../../../components/admin/Breadcrumbs'
import { SpinnerIcon } from '../../../components/icons'

type Track = Database['public']['Tables']['tracks']['Row']
type Bundle = Database['public']['Tables']['bundles']['Row']

interface TrackWithBundles extends Track {
  bundleIds: string[]
  moduleCount: number
}

const levels: TrackLevel[] = ['beginner', 'intermediate', 'advanced']

const emptyDraft = {
  name: '',
  slug: '',
  level: 'beginner' as TrackLevel,
  description: '',
  bundleIds: [] as string[],
}

export function TracksList() {
  const [tracks, setTracks] = useState<TrackWithBundles[]>([])
  const [bundles, setBundles] = useState<Bundle[]>([])
  const [loading, setLoading] = useState(true)
  const [creating, setCreating] = useState(false)
  const [draft, setDraft] = useState(emptyDraft)
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState<string | null>(null)

  async function load() {
    setLoading(true)
    const [{ data: trackRows }, { data: bundleRows }, { data: linkRows }, { data: moduleRows }] =
      await Promise.all([
        supabase.from('tracks').select('*').order('order_index'),
        supabase.from('bundles').select('*').order('price'),
        supabase.from('bundle_tracks').select('*'),
        supabase.from('modules').select('id, track_id'),
      ])
    setTracks(
      (trackRows ?? []).map((t) => ({
        ...t,
        bundleIds: (linkRows ?? []).filter((l) => l.track_id === t.id).map((l) => l.bundle_id),
        moduleCount: (moduleRows ?? []).filter((m) => m.track_id === t.id).length,
      })),
    )
    setBundles(bundleRows ?? [])
    setLoading(false)
  }

  useEffect(() => {
    load()
  }, [])

  function toggleBundle(id: string) {
    setDraft((d) => ({
      ...d,
      bundleIds: d.bundleIds.includes(id)
        ? d.bundleIds.filter((b) => b !== id)
        : [...d.bundleIds, id],
    }))
  }

  async function createTrack() {
    setSaving(true)
    setError(null)
    try {
      const { data: track, error: trackErr } = await supabase
        .from('tracks')
        .insert({
          name: draft.name,
          slug: draft.slug || slugify(draft.name),
          level: draft.level,
          description: draft.description || null,
        })
        .select()
        .single()
      if (trackErr) throw trackErr

      if (draft.bundleIds.length) {
        const { error: linkErr } = await supabase
          .from('bundle_tracks')
          .insert(draft.bundleIds.map((bundle_id) => ({ bundle_id, track_id: track.id })))
        if (linkErr) throw linkErr
      }

      setDraft(emptyDraft)
      setCreating(false)
      await load()
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to create track.')
    } finally {
      setSaving(false)
    }
  }

  return (
    <div className="px-6 py-8">
      <Breadcrumbs items={[{ label: 'Curriculum' }]} />
      <div className="flex items-center justify-between">
        <div>
          <h1 className="font-heading text-2xl text-text">Curriculum</h1>
          <p className="mt-1 text-text-secondary">
            Tracks, modules, lessons, and sections, all editable here.
          </p>
        </div>
        <button
          type="button"
          onClick={() => setCreating((c) => !c)}
          className="rounded-lg bg-accent px-4 py-2 text-sm font-medium text-background hover:opacity-90"
        >
          {creating ? 'Cancel' : 'New track'}
        </button>
      </div>

      {creating && (
        <div className="mt-6 flex flex-col gap-3 rounded-xl border border-border bg-surface p-4">
          <div className="grid gap-3 sm:grid-cols-2">
            <label className="flex flex-col gap-1 text-sm text-text-secondary">
              Name
              <input
                value={draft.name}
                onChange={(e) =>
                  setDraft((d) => ({
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
                value={draft.slug}
                onChange={(e) => setDraft((d) => ({ ...d, slug: slugify(e.target.value) }))}
                className="rounded-lg border border-border bg-background px-3 py-2 text-text"
              />
            </label>
          </div>

          <label className="flex flex-col gap-1 text-sm text-text-secondary">
            Description
            <textarea
              value={draft.description}
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
                  onClick={() => toggleBundle(b.id)}
                  className={`rounded-full border px-3 py-1 text-xs transition-colors ${
                    draft.bundleIds.includes(b.id)
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

          <button
            type="button"
            onClick={createTrack}
            disabled={saving || !draft.name}
            className="w-fit rounded-lg bg-accent px-4 py-2 text-sm font-medium text-background hover:opacity-90 disabled:opacity-50"
          >
            {saving ? 'Creating…' : 'Create track'}
          </button>
        </div>
      )}

      <div className="mt-6 flex flex-col gap-3">
        {loading && (
          <div className="flex justify-center py-10 text-accent">
            <SpinnerIcon className="animate-spin" size={24} />
          </div>
        )}

        {!loading && tracks.length === 0 && (
          <p className="py-10 text-center text-text-secondary">No tracks yet.</p>
        )}

        {!loading &&
          tracks.map((t) => (
            <Link
              key={t.id}
              to={`/admin/curriculum/${t.slug}`}
              className="flex items-center justify-between rounded-xl border border-border bg-surface p-4 transition-colors hover:border-accent/40"
            >
              <div>
                <p className="font-medium text-text">{t.name}</p>
                <p className="text-sm text-text-secondary">
                  {t.moduleCount} module{t.moduleCount === 1 ? '' : 's'}
                  {t.bundleIds.length > 0 &&
                    ` · in ${t.bundleIds
                      .map((id) => bundles.find((b) => b.id === id)?.name)
                      .filter(Boolean)
                      .join(', ')}`}
                </p>
              </div>
              <span className="rounded-full border border-border px-2.5 py-1 text-xs capitalize text-text-secondary">
                {t.level}
              </span>
            </Link>
          ))}
      </div>
    </div>
  )
}
