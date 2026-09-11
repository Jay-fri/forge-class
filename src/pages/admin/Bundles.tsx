import { useEffect, useState } from 'react'
import { supabase } from '../../lib/supabase'
import type { Bundle } from '../../lib/bundles'
import { formatPrice } from '../../lib/bundles'
import { slugify } from '../../lib/slug'
import { SpinnerIcon } from '../../components/icons'
import { BundleCard } from '../../components/marketing/BundleCard'

const emptyDraft = {
  name: '',
  slug: '',
  description: '',
  audience: '',
  price: 0,
  currency: 'NGN',
  whatsapp_group_link: '',
}

export function Bundles() {
  const [bundles, setBundles] = useState<Bundle[]>([])
  const [loading, setLoading] = useState(true)
  const [editingId, setEditingId] = useState<string | null>(null)
  const [draft, setDraft] = useState<Partial<Bundle>>({})
  const [saving, setSaving] = useState(false)
  const [saveError, setSaveError] = useState<string | null>(null)
  const [creating, setCreating] = useState(false)
  const [newBundle, setNewBundle] = useState(emptyDraft)
  const [createError, setCreateError] = useState<string | null>(null)

  async function load() {
    setLoading(true)
    const { data } = await supabase.from('bundles').select('*').order('price')
    setBundles(data ?? [])
    setLoading(false)
  }

  useEffect(() => {
    load()
  }, [])

  function startEdit(bundle: Bundle) {
    setEditingId(bundle.id)
    setDraft(bundle)
    setSaveError(null)
  }

  async function save() {
    if (!editingId) return
    setSaving(true)
    setSaveError(null)
    try {
      const { error } = await supabase
        .from('bundles')
        .update({
          name: draft.name,
          description: draft.description,
          audience: draft.audience,
          price: draft.price,
          is_active: draft.is_active,
          whatsapp_group_link: draft.whatsapp_group_link,
        })
        .eq('id', editingId)
      if (error) throw error
      setEditingId(null)
      await load()
    } catch (err) {
      setSaveError(err instanceof Error ? err.message : 'Failed to save. Try again.')
    } finally {
      setSaving(false)
    }
  }

  async function createBundle() {
    setSaving(true)
    setCreateError(null)
    try {
      const { error } = await supabase.from('bundles').insert({
        name: newBundle.name,
        slug: newBundle.slug || slugify(newBundle.name),
        description: newBundle.description || null,
        audience: newBundle.audience || null,
        price: newBundle.price,
        currency: newBundle.currency,
        whatsapp_group_link: newBundle.whatsapp_group_link || null,
        is_active: true,
      })
      if (error) throw error
      setNewBundle(emptyDraft)
      setCreating(false)
      await load()
    } catch (err) {
      setCreateError(err instanceof Error ? err.message : 'Failed to create bundle.')
    } finally {
      setSaving(false)
    }
  }

  const previewBundle = bundles.find((b) => b.id === editingId)
  const mergedPreview = previewBundle ? { ...previewBundle, ...draft } as Bundle : null

  return (
    <div className="px-6 py-8">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <h1 className="font-heading text-2xl text-text">Bundles & pricing</h1>
          <p className="mt-1 text-text-secondary">
            Changes here update the live landing page immediately.
          </p>
        </div>
        <button
          type="button"
          onClick={() => {
            setCreating((c) => !c)
            setCreateError(null)
          }}
          className="shrink-0 rounded-lg bg-accent px-4 py-2 text-sm font-medium text-background hover:opacity-90"
        >
          {creating ? 'Cancel' : 'New bundle'}
        </button>
      </div>

      {creating && (
        <div className="mt-6 flex flex-col gap-3 rounded-xl border border-border bg-surface p-4">
          <div className="grid gap-3 sm:grid-cols-2">
            <label className="flex flex-col gap-1 text-sm text-text-secondary">
              Name
              <input
                value={newBundle.name}
                onChange={(e) =>
                  setNewBundle((d) => ({
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
                value={newBundle.slug}
                onChange={(e) => setNewBundle((d) => ({ ...d, slug: slugify(e.target.value) }))}
                className="rounded-lg border border-border bg-background px-3 py-2 text-text"
              />
            </label>
          </div>

          <label className="flex flex-col gap-1 text-sm text-text-secondary">
            Description (what's covered)
            <textarea
              value={newBundle.description}
              onChange={(e) => setNewBundle((d) => ({ ...d, description: e.target.value }))}
              rows={2}
              className="rounded-lg border border-border bg-background px-3 py-2 text-text"
            />
          </label>

          <label className="flex flex-col gap-1 text-sm text-text-secondary">
            Audience (who it's for)
            <textarea
              value={newBundle.audience}
              onChange={(e) => setNewBundle((d) => ({ ...d, audience: e.target.value }))}
              rows={2}
              className="rounded-lg border border-border bg-background px-3 py-2 text-text"
            />
          </label>

          <div className="grid gap-3 sm:grid-cols-2">
            <label className="flex flex-col gap-1 text-sm text-text-secondary">
              Price
              <input
                type="number"
                value={newBundle.price}
                onChange={(e) => setNewBundle((d) => ({ ...d, price: Number(e.target.value) }))}
                className="rounded-lg border border-border bg-background px-3 py-2 text-text"
              />
            </label>
            <label className="flex flex-col gap-1 text-sm text-text-secondary">
              Currency
              <input
                value={newBundle.currency}
                onChange={(e) => setNewBundle((d) => ({ ...d, currency: e.target.value }))}
                className="rounded-lg border border-border bg-background px-3 py-2 text-text"
              />
            </label>
          </div>

          <label className="flex flex-col gap-1 text-sm text-text-secondary">
            WhatsApp group invite link
            <input
              value={newBundle.whatsapp_group_link}
              onChange={(e) => setNewBundle((d) => ({ ...d, whatsapp_group_link: e.target.value }))}
              placeholder="https://chat.whatsapp.com/…"
              className="rounded-lg border border-border bg-background px-3 py-2 text-text"
            />
          </label>

          {createError && <p className="text-sm text-red-400">{createError}</p>}

          <div className="mt-1 flex gap-2">
            <button
              onClick={createBundle}
              disabled={saving || !newBundle.name.trim()}
              className="rounded-lg bg-accent px-4 py-2 text-sm font-medium text-background hover:opacity-90 disabled:opacity-60"
            >
              {saving ? 'Creating…' : 'Create bundle'}
            </button>
            <button
              onClick={() => {
                setCreating(false)
                setNewBundle(emptyDraft)
              }}
              className="rounded-lg border border-border px-4 py-2 text-sm text-text-secondary hover:bg-background"
            >
              Cancel
            </button>
          </div>
        </div>
      )}

      {loading ? (
        <div className="flex justify-center py-10 text-accent">
          <SpinnerIcon className="animate-spin" size={24} />
        </div>
      ) : (
        <div className="mt-6 flex flex-col gap-3">
          {bundles.length === 0 && !creating && (
            <p className="py-10 text-center text-text-secondary">
              No bundles yet. Create one to show it on the landing page.
            </p>
          )}
          {bundles.map((b) => (
            <div key={b.id} className="rounded-xl border border-border bg-surface p-4">
              {editingId === b.id ? (
                <div className="grid gap-4 md:grid-cols-2">
                  <div className="flex flex-col gap-3">
                    <label className="flex flex-col gap-1 text-sm text-text-secondary">
                      Name
                      <input
                        value={draft.name ?? ''}
                        onChange={(e) => setDraft((d) => ({ ...d, name: e.target.value }))}
                        className="rounded-lg border border-border bg-background px-3 py-2 text-text"
                      />
                    </label>
                    <label className="flex flex-col gap-1 text-sm text-text-secondary">
                      Description (what's covered)
                      <textarea
                        value={draft.description ?? ''}
                        onChange={(e) =>
                          setDraft((d) => ({ ...d, description: e.target.value }))
                        }
                        rows={2}
                        className="rounded-lg border border-border bg-background px-3 py-2 text-text"
                      />
                    </label>
                    <label className="flex flex-col gap-1 text-sm text-text-secondary">
                      Audience (who it's for)
                      <textarea
                        value={draft.audience ?? ''}
                        onChange={(e) =>
                          setDraft((d) => ({ ...d, audience: e.target.value }))
                        }
                        rows={2}
                        className="rounded-lg border border-border bg-background px-3 py-2 text-text"
                      />
                    </label>
                    <label className="flex flex-col gap-1 text-sm text-text-secondary">
                      Price ({draft.currency})
                      <input
                        type="number"
                        value={draft.price ?? 0}
                        onChange={(e) =>
                          setDraft((d) => ({ ...d, price: Number(e.target.value) }))
                        }
                        className="rounded-lg border border-border bg-background px-3 py-2 text-text"
                      />
                    </label>
                    <label className="flex flex-col gap-1 text-sm text-text-secondary">
                      WhatsApp group invite link
                      <input
                        value={draft.whatsapp_group_link ?? ''}
                        onChange={(e) =>
                          setDraft((d) => ({ ...d, whatsapp_group_link: e.target.value }))
                        }
                        placeholder="https://chat.whatsapp.com/…"
                        className="rounded-lg border border-border bg-background px-3 py-2 text-text"
                      />
                    </label>
                    <label className="flex items-center gap-2 text-sm text-text-secondary">
                      <input
                        type="checkbox"
                        checked={draft.is_active ?? true}
                        onChange={(e) =>
                          setDraft((d) => ({ ...d, is_active: e.target.checked }))
                        }
                      />
                      Active (visible on landing page)
                    </label>

                    {saveError && <p className="text-sm text-red-400">{saveError}</p>}

                    <div className="mt-2 flex gap-2">
                      <button
                        onClick={save}
                        disabled={saving}
                        className="rounded-lg bg-accent px-4 py-2 text-sm font-medium text-background hover:opacity-90 disabled:opacity-60"
                      >
                        {saving ? 'Saving…' : 'Save'}
                      </button>
                      <button
                        onClick={() => setEditingId(null)}
                        className="rounded-lg border border-border px-4 py-2 text-sm text-text-secondary hover:bg-background"
                      >
                        Cancel
                      </button>
                    </div>
                  </div>

                  <div>
                    <p className="mb-2 text-xs uppercase tracking-wide text-text-secondary/70">
                      Live preview
                    </p>
                    {mergedPreview && <BundleCard bundle={mergedPreview} />}
                  </div>
                </div>
              ) : (
                <div className="flex items-center justify-between gap-3">
                  <div className="min-w-0">
                    <p className="truncate font-medium text-text">
                      {b.name}{' '}
                      {!b.is_active && (
                        <span className="ml-2 rounded bg-background px-1.5 py-0.5 text-xs text-text-secondary">
                          hidden
                        </span>
                      )}
                    </p>
                    <p className="text-sm text-text-secondary">
                      {formatPrice(b.price, b.currency)}
                    </p>
                  </div>
                  <button
                    onClick={() => startEdit(b)}
                    className="shrink-0 rounded-lg border border-border px-3 py-1.5 text-sm text-text-secondary hover:bg-background"
                  >
                    Edit
                  </button>
                </div>
              )}
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
