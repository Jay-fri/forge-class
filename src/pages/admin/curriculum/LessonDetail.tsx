import { lazy, Suspense, useEffect, useState } from 'react'
import { Navigate, useParams } from 'react-router-dom'
import { supabase } from '../../../lib/supabase'
import { slugify } from '../../../lib/slug'
import type { Database } from '../../../lib/database.types'
import { Breadcrumbs } from '../../../components/admin/Breadcrumbs'
import { AssignmentEditor } from '../../../components/admin/AssignmentEditor'
import { Markdown } from '../../../components/content/Markdown'
import { SpinnerIcon } from '../../../components/icons'

type Track = Database['public']['Tables']['tracks']['Row']
type Module = Database['public']['Tables']['modules']['Row']
type Lesson = Database['public']['Tables']['lessons']['Row']
type Section = Database['public']['Tables']['sections']['Row']
type Quiz = Database['public']['Tables']['section_quizzes']['Row']

// Sandpack pulls in a large bundler runtime — code-split so pages that
// never show a sandbox (most of them) don't pay for it.
const SandboxEmbed = lazy(() =>
  import('../../../components/content/SandboxEmbed').then((m) => ({ default: m.SandboxEmbed })),
)

export function LessonDetail() {
  const params = useParams<{
    trackSlug: string
    moduleSlug: string
    lessonSlug: string
  }>()
  const trackSlug = params.trackSlug!
  const moduleSlug = params.moduleSlug!
  const lessonSlug = params.lessonSlug!
  const [track, setTrack] = useState<Track | null>(null)
  const [module, setModule] = useState<Module | null>(null)
  const [lesson, setLesson] = useState<Lesson | null>(null)
  const [sections, setSections] = useState<Section[]>([])
  const [notFound, setNotFound] = useState(false)
  const [loading, setLoading] = useState(true)

  const [editingLesson, setEditingLesson] = useState(false)
  const [lessonDraft, setLessonDraft] = useState<Partial<Lesson>>({})
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const [editingSectionId, setEditingSectionId] = useState<string | null>(null)
  const [sectionDraft, setSectionDraft] = useState<Partial<Section>>({})
  const [creatingSection, setCreatingSection] = useState(false)

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

    const { data: lessonRow } = await supabase
      .from('lessons')
      .select('*')
      .eq('module_id', moduleRow.id)
      .eq('slug', lessonSlug)
      .maybeSingle()
    if (!lessonRow) {
      setNotFound(true)
      setLoading(false)
      return
    }
    setLesson(lessonRow)

    const { data: sectionRows } = await supabase
      .from('sections')
      .select('*')
      .eq('lesson_id', lessonRow.id)
      .order('order_index')
    setSections(sectionRows ?? [])
    setLoading(false)
  }

  useEffect(() => {
    load()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [trackSlug, moduleSlug, lessonSlug])

  function startEditLesson() {
    if (!lesson) return
    setLessonDraft(lesson)
    setEditingLesson(true)
    setError(null)
  }

  async function togglePublish() {
    if (!lesson) return
    await supabase
      .from('lessons')
      .update({ status: lesson.status === 'published' ? 'draft' : 'published' })
      .eq('id', lesson.id)
    await load()
  }

  async function saveLesson() {
    if (!lesson) return
    setSaving(true)
    setError(null)
    try {
      const { error: err } = await supabase
        .from('lessons')
        .update({
          title: lessonDraft.title,
          slug: lessonDraft.slug,
          is_free_preview: lessonDraft.is_free_preview,
        })
        .eq('id', lesson.id)
      if (err) throw err
      setEditingLesson(false)
      await load()
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to save lesson.')
    } finally {
      setSaving(false)
    }
  }

  function startEditSection(section: Section) {
    setSectionDraft(section)
    setEditingSectionId(section.id)
    setCreatingSection(false)
    setError(null)
  }

  function startCreateSection() {
    setSectionDraft({ title: '', content: '', section_type: 'concept' })
    setCreatingSection(true)
    setEditingSectionId(null)
    setError(null)
  }

  async function saveSection() {
    if (!lesson) return
    setSaving(true)
    setError(null)
    try {
      if (creatingSection) {
        const { error: err } = await supabase.from('sections').insert({
          lesson_id: lesson.id,
          title: sectionDraft.title || null,
          content: sectionDraft.content || null,
          section_type: sectionDraft.section_type || 'concept',
          sandbox_template: sectionDraft.sandbox_template || null,
          sandbox_files: sectionDraft.sandbox_files || null,
          order_index: sections.length,
        })
        if (err) throw err
      } else if (editingSectionId) {
        const { error: err } = await supabase
          .from('sections')
          .update({
            title: sectionDraft.title,
            content: sectionDraft.content,
            section_type: sectionDraft.section_type || 'concept',
            sandbox_template: sectionDraft.sandbox_template || null,
            sandbox_files: sectionDraft.sandbox_files || null,
          })
          .eq('id', editingSectionId)
        if (err) throw err
      }
      setEditingSectionId(null)
      setCreatingSection(false)
      await load()
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to save section.')
    } finally {
      setSaving(false)
    }
  }

  async function deleteSection(id: string) {
    if (!confirm('Delete this section? This cannot be undone.')) return
    await supabase.from('sections').delete().eq('id', id)
    await load()
  }

  if (notFound) return <Navigate to="/admin/curriculum" replace />

  if (loading || !track || !module || !lesson) {
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
          { label: module.name, to: `/admin/curriculum/${track.slug}/${module.slug}` },
          { label: lesson.title },
        ]}
      />

      {editingLesson ? (
        <div className="flex flex-col gap-3 rounded-xl border border-border bg-surface p-4">
          <div className="grid gap-3 sm:grid-cols-2">
            <label className="flex flex-col gap-1 text-sm text-text-secondary">
              Title
              <input
                value={lessonDraft.title ?? ''}
                onChange={(e) => setLessonDraft((d) => ({ ...d, title: e.target.value }))}
                className="rounded-lg border border-border bg-background px-3 py-2 text-text"
              />
            </label>
            <label className="flex flex-col gap-1 text-sm text-text-secondary">
              Slug
              <input
                value={lessonDraft.slug ?? ''}
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
              checked={lessonDraft.is_free_preview ?? false}
              onChange={(e) =>
                setLessonDraft((d) => ({ ...d, is_free_preview: e.target.checked }))
              }
            />
            Free preview (visible to pending/unapproved students)
          </label>
          {error && <p className="text-sm text-red-400">{error}</p>}
          <div className="flex gap-2">
            <button
              onClick={saveLesson}
              disabled={saving}
              className="rounded-lg bg-accent px-4 py-2 text-sm font-medium text-background hover:opacity-90 disabled:opacity-60"
            >
              {saving ? 'Saving…' : 'Save'}
            </button>
            <button
              onClick={() => setEditingLesson(false)}
              className="rounded-lg border border-border px-4 py-2 text-sm text-text-secondary hover:bg-background"
            >
              Cancel
            </button>
          </div>
        </div>
      ) : (
        <div className="flex items-start justify-between">
          <div>
            <h1 className="font-heading text-2xl text-text">{lesson.title}</h1>
            <div className="mt-1 flex items-center gap-2">
              {lesson.status === 'published' ? (
                <span className="inline-block rounded-full border border-success/40 px-2 py-0.5 text-xs text-success">
                  Published
                </span>
              ) : (
                <span className="inline-block rounded-full border border-accent/40 px-2 py-0.5 text-xs text-accent">
                  Draft, hidden from students
                </span>
              )}
              {lesson.is_free_preview && (
                <span className="inline-block rounded-full border border-border px-2 py-0.5 text-xs text-text-secondary">
                  Free preview
                </span>
              )}
            </div>
          </div>
          <div className="flex gap-2">
            <button
              onClick={togglePublish}
              className={`rounded-lg border px-3 py-1.5 text-sm ${
                lesson.status === 'published'
                  ? 'border-border text-text-secondary hover:bg-surface'
                  : 'border-accent bg-accent/10 text-accent hover:bg-accent/20'
              }`}
            >
              {lesson.status === 'published' ? 'Unpublish' : 'Publish'}
            </button>
            <button
              onClick={startEditLesson}
              className="rounded-lg border border-border px-3 py-1.5 text-sm text-text-secondary hover:bg-surface"
            >
              Edit lesson
            </button>
          </div>
        </div>
      )}

      <div className="mt-8 flex items-center justify-between">
        <h2 className="font-heading text-lg text-text">Sections</h2>
        {!creatingSection && (
          <button
            type="button"
            onClick={startCreateSection}
            className="rounded-lg bg-accent px-3.5 py-1.5 text-sm font-medium text-background hover:opacity-90"
          >
            New section
          </button>
        )}
      </div>

      {creatingSection && (
        <SectionForm
          draft={sectionDraft}
          setDraft={setSectionDraft}
          onSave={saveSection}
          onCancel={() => setCreatingSection(false)}
          saving={saving}
          error={error}
        />
      )}

      <div className="mt-3 flex flex-col gap-3">
        {sections.length === 0 && !creatingSection && (
          <p className="py-8 text-center text-text-secondary">No sections yet.</p>
        )}
        {sections.map((s) =>
          editingSectionId === s.id ? (
            <SectionForm
              key={s.id}
              draft={sectionDraft}
              setDraft={setSectionDraft}
              onSave={saveSection}
              onCancel={() => setEditingSectionId(null)}
              saving={saving}
              error={error}
            />
          ) : (
            <div key={s.id} className="rounded-xl border border-border bg-surface p-4">
              <div className="flex items-center justify-between gap-3">
                {s.title && <h3 className="min-w-0 truncate font-medium text-text">{s.title}</h3>}
                <div className="ml-auto flex shrink-0 gap-2">
                  <button
                    onClick={() => startEditSection(s)}
                    className="rounded-lg border border-border px-3 py-1 text-xs text-text-secondary hover:bg-background"
                  >
                    Edit
                  </button>
                  <button
                    onClick={() => deleteSection(s.id)}
                    className="rounded-lg border border-border px-3 py-1 text-xs text-red-400 hover:bg-background"
                  >
                    Delete
                  </button>
                </div>
              </div>
              {s.content && (
                <div className="mt-3">
                  <Markdown>{s.content}</Markdown>
                </div>
              )}
              {s.sandbox_files && (
                <div className="mt-3">
                  <Suspense
                    fallback={
                      <div className="flex h-40 items-center justify-center rounded-lg border border-border bg-background text-accent">
                        <SpinnerIcon className="animate-spin" size={20} />
                      </div>
                    }
                  >
                    <SandboxEmbed
                      template={s.sandbox_template ?? 'vanilla'}
                      files={s.sandbox_files}
                    />
                  </Suspense>
                </div>
              )}
              <div className="mt-4 border-t border-border pt-4">
                <QuizManager sectionId={s.id} />
              </div>
            </div>
          ),
        )}
      </div>

      <div className="mt-8">
        <AssignmentEditor parentType="lesson" parentId={lesson.id} />
      </div>
    </div>
  )
}

function SectionForm({
  draft,
  setDraft,
  onSave,
  onCancel,
  saving,
  error,
}: {
  draft: Partial<Section>
  setDraft: (fn: (d: Partial<Section>) => Partial<Section>) => void
  onSave: () => void
  onCancel: () => void
  saving: boolean
  error: string | null
}) {
  const [sandboxOpen, setSandboxOpen] = useState(Boolean(draft.sandbox_files))
  const [filesText, setFilesText] = useState(
    draft.sandbox_files ? JSON.stringify(draft.sandbox_files, null, 2) : '',
  )
  const [filesError, setFilesError] = useState<string | null>(null)

  function handleFilesTextChange(text: string) {
    setFilesText(text)
    if (!text.trim()) {
      setDraft((d) => ({ ...d, sandbox_files: null }))
      setFilesError(null)
      return
    }
    try {
      const parsed = JSON.parse(text)
      setDraft((d) => ({ ...d, sandbox_files: parsed }))
      setFilesError(null)
    } catch {
      setFilesError('Invalid JSON, not saved until this is fixed.')
    }
  }

  return (
    <div className="grid gap-4 rounded-xl border border-border bg-surface p-4 lg:grid-cols-2">
      <div className="flex flex-col gap-3">
        <label className="flex flex-col gap-1 text-sm text-text-secondary">
          Type
          <select
            value={draft.section_type ?? 'concept'}
            onChange={(e) =>
              setDraft((d) => ({ ...d, section_type: e.target.value as Section['section_type'] }))
            }
            className="w-fit rounded-lg border border-border bg-background px-3 py-2 text-text"
          >
            <option value="concept">Concept</option>
            <option value="code_example">Code example</option>
            <option value="try_it">Try it</option>
            <option value="check_in">Check-in (pairs with a quiz below)</option>
            <option value="common_mistake">Common mistake</option>
          </select>
        </label>
        <label className="flex flex-col gap-1 text-sm text-text-secondary">
          Title (optional)
          <input
            value={draft.title ?? ''}
            onChange={(e) => setDraft((d) => ({ ...d, title: e.target.value }))}
            className="rounded-lg border border-border bg-background px-3 py-2 text-text"
          />
        </label>
        <label className="flex flex-col gap-1 text-sm text-text-secondary">
          Content (Markdown)
          <textarea
            value={draft.content ?? ''}
            onChange={(e) => setDraft((d) => ({ ...d, content: e.target.value }))}
            rows={14}
            className="rounded-lg border border-border bg-background px-3 py-2 font-mono text-sm text-text"
          />
        </label>

        <button
          type="button"
          onClick={() => setSandboxOpen((o) => !o)}
          className="w-fit text-sm text-accent hover:underline"
        >
          {sandboxOpen ? 'Hide sandbox' : '+ Add interactive sandbox'}
        </button>

        {sandboxOpen && (
          <div className="flex flex-col gap-2 rounded-lg border border-border p-3">
            <label className="flex flex-col gap-1 text-sm text-text-secondary">
              Template
              <select
                value={draft.sandbox_template ?? 'vanilla'}
                onChange={(e) => setDraft((d) => ({ ...d, sandbox_template: e.target.value }))}
                className="w-fit rounded-lg border border-border bg-background px-3 py-2 text-text"
              >
                <option value="vanilla">vanilla (HTML/CSS/JS)</option>
                <option value="react">react</option>
                <option value="static">static</option>
              </select>
            </label>
            <label className="flex flex-col gap-1 text-sm text-text-secondary">
              Files (JSON, e.g. {'{"/index.html": "<h1>Hi</h1>"}'})
              <textarea
                value={filesText}
                onChange={(e) => handleFilesTextChange(e.target.value)}
                rows={8}
                className="rounded-lg border border-border bg-background px-3 py-2 font-mono text-xs text-text"
              />
            </label>
            {filesError && <p className="text-sm text-red-400">{filesError}</p>}
          </div>
        )}

        {error && <p className="text-sm text-red-400">{error}</p>}
        <div className="flex gap-2">
          <button
            onClick={onSave}
            disabled={saving}
            className="rounded-lg bg-accent px-4 py-2 text-sm font-medium text-background hover:opacity-90 disabled:opacity-60"
          >
            {saving ? 'Saving…' : 'Save'}
          </button>
          <button
            onClick={onCancel}
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
        <div className="rounded-lg border border-border bg-background p-4">
          {draft.title && <h3 className="mb-2 font-heading text-lg text-text">{draft.title}</h3>}
          {draft.content && <Markdown>{draft.content}</Markdown>}
        </div>
      </div>
    </div>
  )
}

const emptyQuizDraft = { question: '', optionsText: '', correct_index: 0, explanation: '' }

function QuizManager({ sectionId }: { sectionId: string }) {
  const [quizzes, setQuizzes] = useState<Quiz[]>([])
  const [loading, setLoading] = useState(true)
  const [creating, setCreating] = useState(false)
  const [editingId, setEditingId] = useState<string | null>(null)
  const [draft, setDraft] = useState(emptyQuizDraft)
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState<string | null>(null)

  async function load() {
    const { data } = await supabase
      .from('section_quizzes')
      .select('*')
      .eq('section_id', sectionId)
      .order('order_index')
    setQuizzes(data ?? [])
    setLoading(false)
  }

  useEffect(() => {
    load()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sectionId])

  function startCreate() {
    setDraft(emptyQuizDraft)
    setCreating(true)
    setEditingId(null)
    setError(null)
  }

  function startEdit(q: Quiz) {
    setDraft({
      question: q.question,
      optionsText: q.options.join('\n'),
      correct_index: q.correct_index,
      explanation: q.explanation ?? '',
    })
    setEditingId(q.id)
    setCreating(false)
    setError(null)
  }

  async function save() {
    const options = draft.optionsText.split('\n').map((o) => o.trim()).filter(Boolean)
    if (options.length < 2) {
      setError('Add at least two options (one per line).')
      return
    }
    if (draft.correct_index < 0 || draft.correct_index >= options.length) {
      setError(`Correct option index must be between 0 and ${options.length - 1}.`)
      return
    }
    setSaving(true)
    setError(null)
    try {
      if (creating) {
        const { error: err } = await supabase.from('section_quizzes').insert({
          section_id: sectionId,
          question: draft.question,
          options,
          correct_index: draft.correct_index,
          explanation: draft.explanation || null,
          order_index: quizzes.length,
        })
        if (err) throw err
      } else if (editingId) {
        const { error: err } = await supabase
          .from('section_quizzes')
          .update({
            question: draft.question,
            options,
            correct_index: draft.correct_index,
            explanation: draft.explanation || null,
          })
          .eq('id', editingId)
        if (err) throw err
      }
      setCreating(false)
      setEditingId(null)
      await load()
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to save quiz.')
    } finally {
      setSaving(false)
    }
  }

  async function remove(id: string) {
    if (!confirm('Delete this quiz check?')) return
    await supabase.from('section_quizzes').delete().eq('id', id)
    await load()
  }

  if (loading) return null

  const isEditing = creating || editingId

  return (
    <div>
      <div className="flex items-center justify-between">
        <p className="text-xs uppercase tracking-wide text-text-secondary/70">
          Quiz checks ({quizzes.length})
        </p>
        {!isEditing && (
          <button
            type="button"
            onClick={startCreate}
            className="text-sm text-accent hover:underline"
          >
            + Add quiz check
          </button>
        )}
      </div>

      {!isEditing && quizzes.length > 0 && (
        <ul className="mt-2 flex flex-col gap-1.5">
          {quizzes.map((q) => (
            <li
              key={q.id}
              className="flex items-center justify-between gap-3 rounded-lg border border-border px-3 py-2 text-sm"
            >
              <span className="min-w-0 truncate text-text">{q.question}</span>
              <span className="flex shrink-0 gap-2">
                <button
                  onClick={() => startEdit(q)}
                  className="text-xs text-text-secondary hover:text-text"
                >
                  Edit
                </button>
                <button
                  onClick={() => remove(q.id)}
                  className="text-xs text-red-400 hover:underline"
                >
                  Delete
                </button>
              </span>
            </li>
          ))}
        </ul>
      )}

      {isEditing && (
        <div className="mt-2 flex flex-col gap-2 rounded-lg border border-border bg-background p-3">
          <label className="flex flex-col gap-1 text-sm text-text-secondary">
            Question
            <input
              value={draft.question}
              onChange={(e) => setDraft((d) => ({ ...d, question: e.target.value }))}
              className="rounded-lg border border-border bg-surface px-3 py-2 text-text"
            />
          </label>
          <label className="flex flex-col gap-1 text-sm text-text-secondary">
            Options (one per line)
            <textarea
              value={draft.optionsText}
              onChange={(e) => setDraft((d) => ({ ...d, optionsText: e.target.value }))}
              rows={4}
              className="rounded-lg border border-border bg-surface px-3 py-2 font-mono text-sm text-text"
            />
          </label>
          <label className="flex flex-col gap-1 text-sm text-text-secondary">
            Correct option index (0-based)
            <input
              type="number"
              min={0}
              value={draft.correct_index}
              onChange={(e) =>
                setDraft((d) => ({ ...d, correct_index: Number(e.target.value) }))
              }
              className="w-24 rounded-lg border border-border bg-surface px-3 py-2 text-text"
            />
          </label>
          <label className="flex flex-col gap-1 text-sm text-text-secondary">
            Explanation (optional)
            <textarea
              value={draft.explanation}
              onChange={(e) => setDraft((d) => ({ ...d, explanation: e.target.value }))}
              rows={2}
              className="rounded-lg border border-border bg-surface px-3 py-2 text-text"
            />
          </label>
          {error && <p className="text-sm text-red-400">{error}</p>}
          <div className="flex gap-2">
            <button
              onClick={save}
              disabled={saving}
              className="w-fit rounded-lg bg-accent px-4 py-2 text-sm font-medium text-background hover:opacity-90 disabled:opacity-60"
            >
              {saving ? 'Saving…' : 'Save'}
            </button>
            <button
              onClick={() => {
                setCreating(false)
                setEditingId(null)
              }}
              className="w-fit rounded-lg border border-border px-4 py-2 text-sm text-text-secondary hover:bg-surface"
            >
              Cancel
            </button>
          </div>
        </div>
      )}
    </div>
  )
}
