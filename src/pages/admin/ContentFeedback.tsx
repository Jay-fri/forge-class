import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { supabase } from '../../lib/supabase'
import type { Database } from '../../lib/database.types'
import { MessageIcon, PencilIcon, SpinnerIcon } from '../../components/icons'

type Feedback = Database['public']['Tables']['content_feedback']['Row']

interface FeedbackRow extends Feedback {
  sectionTitle: string | null
  studentName: string
  trackSlug: string
  moduleSlug: string
  lessonSlug: string
}

export function ContentFeedback() {
  const [items, setItems] = useState<FeedbackRow[]>([])
  const [loading, setLoading] = useState(true)
  const [showResolved, setShowResolved] = useState(false)

  async function load() {
    setLoading(true)
    const [
      { data: feedbackRows },
      { data: sections },
      { data: lessons },
      { data: modules },
      { data: tracks },
      { data: profiles },
    ] = await Promise.all([
      supabase.from('content_feedback').select('*').order('created_at', { ascending: false }),
      supabase.from('sections').select('id, title, lesson_id'),
      supabase.from('lessons').select('id, slug, module_id'),
      supabase.from('modules').select('id, slug, track_id'),
      supabase.from('tracks').select('id, slug'),
      supabase.from('profiles').select('*'),
    ])

    setItems(
      (feedbackRows ?? []).flatMap((f) => {
        const section = sections?.find((s) => s.id === f.section_id)
        const lesson = lessons?.find((l) => l.id === section?.lesson_id)
        const module_ = modules?.find((m) => m.id === lesson?.module_id)
        const track = tracks?.find((t) => t.id === module_?.track_id)
        const student = profiles?.find((p) => p.id === f.user_id)
        if (!section || !lesson || !module_ || !track) return []
        return [
          {
            ...f,
            sectionTitle: section.title,
            studentName: student?.full_name ?? 'A student',
            trackSlug: track.slug,
            moduleSlug: module_.slug,
            lessonSlug: lesson.slug,
          },
        ]
      }),
    )
    setLoading(false)
  }

  useEffect(() => {
    load()
  }, [])

  async function resolve(id: string) {
    await supabase.from('content_feedback').update({ status: 'resolved' }).eq('id', id)
    await load()
  }

  const visible = items.filter((i) => (showResolved ? true : i.status === 'open'))

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
          <h1 className="font-heading text-2xl text-text">Content feedback</h1>
          <p className="mt-1 text-text-secondary">
            What students flagged as confusing or typo'd, tied to the exact section.
          </p>
        </div>
        <label className="flex items-center gap-2 text-sm text-text-secondary">
          <input
            type="checkbox"
            checked={showResolved}
            onChange={(e) => setShowResolved(e.target.checked)}
          />
          Show resolved
        </label>
      </div>

      <div className="mt-6 flex flex-col gap-2">
        {visible.map((f) => (
          <div
            key={f.id}
            className={`flex items-start justify-between gap-4 rounded-xl border px-4 py-3 ${
              f.status === 'resolved' ? 'border-border bg-surface opacity-60' : 'border-border bg-surface'
            }`}
          >
            <div className="flex min-w-0 items-start gap-3">
              {f.feedback_type === 'confusing' ? (
                <MessageIcon className="mt-0.5 shrink-0 text-accent" size={16} />
              ) : (
                <PencilIcon className="mt-0.5 shrink-0 text-accent" size={16} />
              )}
              <div className="min-w-0">
                <Link
                  to={`/admin/curriculum/${f.trackSlug}/${f.moduleSlug}/${f.lessonSlug}`}
                  className="truncate text-text hover:text-accent hover:underline"
                >
                  {f.sectionTitle ?? 'Untitled section'}
                </Link>
                <p className="truncate text-sm text-text-secondary">
                  {f.feedback_type === 'confusing' ? 'Confusing' : 'Typo'} · {f.studentName}
                </p>
                {f.note && <p className="mt-1 wrap-break-word text-sm text-text-secondary">{f.note}</p>}
              </div>
            </div>
            {f.status === 'open' && (
              <button
                onClick={() => resolve(f.id)}
                className="shrink-0 rounded-lg border border-border px-3 py-1.5 text-xs text-text-secondary hover:bg-background"
              >
                Mark resolved
              </button>
            )}
          </div>
        ))}
        {visible.length === 0 && (
          <p className="py-10 text-center text-text-secondary">
            {showResolved ? 'No feedback yet.' : 'Nothing open right now.'}
          </p>
        )}
      </div>
    </div>
  )
}
