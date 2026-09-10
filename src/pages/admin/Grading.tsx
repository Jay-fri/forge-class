import { useEffect, useState } from 'react'
import { supabase } from '../../lib/supabase'
import type { Database } from '../../lib/database.types'
import { SpinnerIcon } from '../../components/icons'

type Submission = Database['public']['Tables']['submissions']['Row']
type Assignment = Database['public']['Tables']['assignments']['Row']
type Profile = Database['public']['Tables']['profiles']['Row']

interface SubmissionRow extends Submission {
  assignment: Assignment | undefined
  student: Profile | undefined
}

export function Grading() {
  const [submissions, setSubmissions] = useState<SubmissionRow[]>([])
  const [loading, setLoading] = useState(true)
  const [selectedId, setSelectedId] = useState<string | null>(null)
  const [feedback, setFeedback] = useState('')
  const [score, setScore] = useState('')
  const [passed, setPassed] = useState<boolean | null>(null)
  const [fileUrl, setFileUrl] = useState<string | null>(null)
  const [saving, setSaving] = useState(false)

  async function load() {
    setLoading(true)
    const [{ data: subs }, { data: assignments }, { data: profiles }] = await Promise.all([
      supabase.from('submissions').select('*').order('submitted_at', { ascending: false }),
      supabase.from('assignments').select('*'),
      supabase.from('profiles').select('*'),
    ])
    setSubmissions(
      (subs ?? []).map((s) => ({
        ...s,
        assignment: assignments?.find((a) => a.id === s.assignment_id),
        student: profiles?.find((p) => p.id === s.student_id),
      })),
    )
    setLoading(false)
  }

  useEffect(() => {
    load()
  }, [])

  const selected = submissions.find((s) => s.id === selectedId) ?? null

  async function select(sub: SubmissionRow) {
    setSelectedId(sub.id)
    setFeedback(sub.feedback ?? '')
    setScore(sub.score?.toString() ?? '')
    setPassed(sub.passed)
    setFileUrl(null)
    if (sub.submission_type === 'file' && sub.file_path) {
      const { data } = await supabase.storage
        .from('submissions')
        .createSignedUrl(sub.file_path, 60 * 10)
      setFileUrl(data?.signedUrl ?? null)
    }
    if (sub.status === 'submitted') {
      await supabase.from('submissions').update({ status: 'in_review' }).eq('id', sub.id)
      setSubmissions((prev) =>
        prev.map((s) => (s.id === sub.id ? { ...s, status: 'in_review' } : s)),
      )
    }
  }

  async function saveGrade() {
    if (!selected) return
    setSaving(true)
    const {
      data: { user },
    } = await supabase.auth.getUser()
    await supabase
      .from('submissions')
      .update({
        status: 'graded',
        feedback: feedback || null,
        score: score ? Number(score) : null,
        passed,
        graded_at: new Date().toISOString(),
        graded_by: user?.id,
      })
      .eq('id', selected.id)
    setSaving(false)

    // Inbox-style: jump straight to the next item waiting, instead of
    // dropping back to the list.
    const next = submissions.find((s) => s.status !== 'graded' && s.id !== selected.id)
    if (next) {
      await select(next)
    } else {
      setSelectedId(null)
    }
    await load()
  }

  if (loading) {
    return (
      <div className="flex justify-center py-20 text-accent">
        <SpinnerIcon className="animate-spin" size={24} />
      </div>
    )
  }

  const pending = submissions.filter((s) => s.status !== 'graded')
  const graded = submissions.filter((s) => s.status === 'graded')

  if (selected) {
    return (
      <div className="px-6 py-8">
        <button
          onClick={() => setSelectedId(null)}
          className="text-sm text-text-secondary hover:text-text"
        >
          ← Back to list
        </button>

        <div className="mt-4 grid gap-6 lg:grid-cols-2">
          <div>
            <h1 className="font-heading text-xl text-text">{selected.assignment?.title}</h1>
            <p className="mt-1 text-sm text-text-secondary">
              {selected.student?.full_name} · submitted{' '}
              {new Date(selected.submitted_at).toLocaleDateString()}
            </p>

            <div className="mt-4 rounded-xl border border-border bg-surface p-4">
              {selected.submission_type === 'code' && (
                <pre className="overflow-x-auto whitespace-pre-wrap font-mono text-sm text-text">
                  {selected.code_content}
                </pre>
              )}
              {selected.submission_type === 'link' && (
                <a
                  href={selected.link_url ?? '#'}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="break-all text-accent hover:underline"
                >
                  {selected.link_url}
                </a>
              )}
              {selected.submission_type === 'file' && (
                <a
                  href={fileUrl ?? '#'}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-accent hover:underline"
                >
                  {fileUrl ? 'Download submitted file' : 'Loading file link…'}
                </a>
              )}
              {selected.explanation && (
                <p className="mt-3 border-t border-border pt-3 text-sm text-text-secondary">
                  {selected.explanation}
                </p>
              )}
            </div>
          </div>

          <div className="flex flex-col gap-3 rounded-xl border border-border bg-surface p-4">
            <h2 className="font-heading text-lg text-text">Grade</h2>
            <label className="flex flex-col gap-1 text-sm text-text-secondary">
              Feedback
              <textarea
                value={feedback}
                onChange={(e) => setFeedback(e.target.value)}
                rows={5}
                className="rounded-lg border border-border bg-background px-3 py-2 text-text"
              />
            </label>
            <label className="flex flex-col gap-1 text-sm text-text-secondary">
              Score (optional)
              <input
                type="number"
                value={score}
                onChange={(e) => setScore(e.target.value)}
                className="w-32 rounded-lg border border-border bg-background px-3 py-2 text-text"
              />
            </label>
            <div className="flex gap-2">
              <button
                type="button"
                onClick={() => setPassed(true)}
                className={`rounded-lg border px-4 py-2 text-sm ${
                  passed === true
                    ? 'border-success/50 bg-success/10 text-success'
                    : 'border-border text-text-secondary hover:bg-background'
                }`}
              >
                Pass
              </button>
              <button
                type="button"
                onClick={() => setPassed(false)}
                className={`rounded-lg border px-4 py-2 text-sm ${
                  passed === false
                    ? 'border-red-400/50 bg-red-400/10 text-red-300'
                    : 'border-border text-text-secondary hover:bg-background'
                }`}
              >
                Needs work
              </button>
            </div>
            <button
              onClick={saveGrade}
              disabled={saving}
              className="mt-2 w-fit rounded-lg bg-accent px-4 py-2 text-sm font-medium text-background hover:opacity-90 disabled:opacity-60"
            >
              {saving ? 'Saving…' : 'Save grade'}
            </button>
          </div>
        </div>
      </div>
    )
  }

  return (
    <div className="px-6 py-8">
      <h1 className="font-heading text-2xl text-text">Grading</h1>
      <p className="mt-1 text-text-secondary">
        {pending.length} submission{pending.length === 1 ? '' : 's'} waiting.
      </p>

      <div className="mt-6 flex flex-col gap-2">
        {pending.map((s) => (
          <button
            key={s.id}
            onClick={() => select(s)}
            className="flex items-center justify-between gap-3 rounded-xl border border-border bg-surface px-4 py-3 text-left transition-colors hover:border-accent/40"
          >
            <div className="min-w-0">
              <p className="truncate font-medium text-text">{s.assignment?.title}</p>
              <p className="truncate text-sm text-text-secondary">{s.student?.full_name}</p>
            </div>
            <span
              className={`shrink-0 rounded-full border px-2.5 py-1 text-xs capitalize ${
                s.status === 'in_review'
                  ? 'border-accent/40 text-accent'
                  : 'border-border text-text-secondary'
              }`}
            >
              {s.status.replace('_', ' ')}
            </span>
          </button>
        ))}
        {pending.length === 0 && (
          <p className="py-8 text-center text-text-secondary">Nothing waiting to be graded.</p>
        )}
      </div>

      {graded.length > 0 && (
        <>
          <h2 className="mt-8 font-heading text-lg text-text">Graded</h2>
          <div className="mt-3 flex flex-col gap-2">
            {graded.map((s) => (
              <button
                key={s.id}
                onClick={() => select(s)}
                className="flex items-center justify-between gap-3 rounded-xl border border-border bg-surface px-4 py-3 text-left opacity-70 transition-colors hover:border-accent/40 hover:opacity-100"
              >
                <div className="min-w-0">
                  <p className="truncate font-medium text-text">{s.assignment?.title}</p>
                  <p className="truncate text-sm text-text-secondary">{s.student?.full_name}</p>
                </div>
                <span
                  className={`shrink-0 rounded-full border px-2.5 py-1 text-xs ${
                    s.passed
                      ? 'border-success/40 text-success'
                      : 'border-border text-text-secondary'
                  }`}
                >
                  {s.passed === true ? 'Passed' : s.passed === false ? 'Needs work' : 'Graded'}
                </span>
              </button>
            ))}
          </div>
        </>
      )}
    </div>
  )
}
