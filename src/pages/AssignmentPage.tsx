import { lazy, Suspense, useEffect, useState } from 'react'
import { Link, Navigate, useParams } from 'react-router-dom'
import { supabase } from '../lib/supabase'
import type { Database, SubmissionType } from '../lib/database.types'
import { Markdown } from '../components/content/Markdown'
import { CheckCircleIcon, ChevronLeftIcon, SpinnerIcon } from '../components/icons'

const SandboxEmbed = lazy(() =>
  import('../components/content/SandboxEmbed').then((m) => ({ default: m.SandboxEmbed })),
)

type Assignment = Database['public']['Tables']['assignments']['Row']
type Submission = Database['public']['Tables']['submissions']['Row']

export function AssignmentPage() {
  const { assignmentId } = useParams<{ assignmentId: string }>()
  const [assignment, setAssignment] = useState<Assignment | null>(null)
  const [submission, setSubmission] = useState<Submission | null>(null)
  const [notFound, setNotFound] = useState(false)
  const [loading, setLoading] = useState(true)

  const [type, setType] = useState<SubmissionType>('code')
  const [codeContent, setCodeContent] = useState('')
  const [linkUrl, setLinkUrl] = useState('')
  const [file, setFile] = useState<File | null>(null)
  const [explanation, setExplanation] = useState('')
  const [submitting, setSubmitting] = useState(false)
  const [error, setError] = useState<string | null>(null)

  async function load() {
    const { data: assignmentRow } = await supabase
      .from('assignments')
      .select('*')
      .eq('id', assignmentId!)
      .maybeSingle()
    if (!assignmentRow) {
      setNotFound(true)
      setLoading(false)
      return
    }
    setAssignment(assignmentRow)

    const {
      data: { user },
    } = await supabase.auth.getUser()
    if (user) {
      const { data: submissionRow } = await supabase
        .from('submissions')
        .select('*')
        .eq('assignment_id', assignmentRow.id)
        .eq('student_id', user.id)
        .order('submitted_at', { ascending: false })
        .maybeSingle()
      setSubmission(submissionRow)
      if (submissionRow) {
        setType(submissionRow.submission_type)
        setCodeContent(submissionRow.code_content ?? '')
        setLinkUrl(submissionRow.link_url ?? '')
        setExplanation(submissionRow.explanation ?? '')
      }
    }
    setLoading(false)
  }

  useEffect(() => {
    load()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [assignmentId])

  async function handleSubmit() {
    if (!assignment) return
    setSubmitting(true)
    setError(null)
    try {
      const {
        data: { user },
      } = await supabase.auth.getUser()
      if (!user) throw new Error('Not signed in.')

      let filePath: string | null = submission?.file_path ?? null
      if (type === 'file' && file) {
        filePath = `${user.id}/${assignment.id}/${file.name}`
        const { error: uploadErr } = await supabase.storage
          .from('submissions')
          .upload(filePath, file, { upsert: true })
        if (uploadErr) throw uploadErr
      }

      const payload = {
        assignment_id: assignment.id,
        student_id: user.id,
        submission_type: type,
        code_content: type === 'code' ? codeContent : null,
        link_url: type === 'link' ? linkUrl : null,
        file_path: type === 'file' ? filePath : null,
        explanation: explanation || null,
        status: 'submitted' as const,
        submitted_at: new Date().toISOString(),
      }

      if (submission) {
        const { error: err } = await supabase
          .from('submissions')
          .update(payload)
          .eq('id', submission.id)
        if (err) throw err
      } else {
        const { error: err } = await supabase.from('submissions').insert(payload)
        if (err) throw err
      }
      await load()
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to submit.')
    } finally {
      setSubmitting(false)
    }
  }

  if (notFound) return <Navigate to="/learn" replace />

  if (loading || !assignment) {
    return (
      <div className="flex min-h-svh items-center justify-center bg-background text-accent">
        <SpinnerIcon className="animate-spin" size={28} />
      </div>
    )
  }

  const canEdit = !submission || submission.status === 'submitted'

  return (
    <div className="min-h-svh bg-background">
      <header className="border-b border-border px-4 py-3">
        <div className="mx-auto flex max-w-2xl items-center gap-3">
          <Link to="/learn" className="text-text-secondary hover:text-text">
            <ChevronLeftIcon size={22} />
          </Link>
          <h1 className="truncate font-heading text-lg text-text">{assignment.title}</h1>
        </div>
      </header>

      <div className="mx-auto flex max-w-2xl flex-col gap-5 px-5 py-6">
        <Markdown>{assignment.spec}</Markdown>

        {assignment.starter_code && (
          <Suspense
            fallback={
              <div className="flex h-64 items-center justify-center rounded-lg border border-border bg-surface text-accent">
                <SpinnerIcon className="animate-spin" size={22} />
              </div>
            }
          >
            <SandboxEmbed
              template={assignment.starter_template ?? 'vanilla'}
              files={assignment.starter_code}
            />
          </Suspense>
        )}

        {submission && (
          <div
            className={`rounded-xl border px-4 py-3 ${
              submission.status === 'graded'
                ? submission.passed
                  ? 'border-success/40 bg-success/5'
                  : 'border-border bg-surface'
                : 'border-accent/30 bg-accent/5'
            }`}
          >
            <p className="flex items-center gap-2 text-sm font-medium text-text">
              {submission.status === 'graded' && submission.passed && (
                <CheckCircleIcon className="text-success" size={16} />
              )}
              Status: {submission.status === 'in_review' ? 'In review' : submission.status === 'graded' ? 'Graded' : 'Submitted'}
              {submission.status === 'graded' &&
                submission.passed !== null &&
                ` — ${submission.passed ? 'Passed' : 'Needs work'}`}
              {submission.score !== null && ` · Score: ${submission.score}`}
            </p>
            {submission.feedback && (
              <p className="mt-2 text-sm text-text-secondary">{submission.feedback}</p>
            )}
          </div>
        )}

        {canEdit && (
          <div className="flex flex-col gap-3">
            <div className="flex gap-2">
              {(['code', 'file', 'link'] as SubmissionType[]).map((t) => (
                <button
                  key={t}
                  type="button"
                  onClick={() => setType(t)}
                  className={`rounded-full border px-3.5 py-1.5 text-sm capitalize transition-colors ${
                    type === t
                      ? 'border-accent bg-accent/10 text-accent'
                      : 'border-border text-text-secondary hover:border-accent/40'
                  }`}
                >
                  {t}
                </button>
              ))}
            </div>

            {type === 'code' && (
              <textarea
                value={codeContent}
                onChange={(e) => setCodeContent(e.target.value)}
                rows={10}
                placeholder="Paste your code here"
                className="rounded-lg border border-border bg-surface px-3 py-2 font-mono text-sm text-text outline-none focus:border-accent"
              />
            )}
            {type === 'link' && (
              <input
                value={linkUrl}
                onChange={(e) => setLinkUrl(e.target.value)}
                placeholder="https://your-deployed-project.com"
                className="rounded-lg border border-border bg-surface px-3.5 py-2.5 text-text outline-none focus:border-accent"
              />
            )}
            {type === 'file' && (
              <input
                type="file"
                onChange={(e) => setFile(e.target.files?.[0] ?? null)}
                className="text-sm text-text-secondary file:mr-3 file:rounded-lg file:border-0 file:bg-accent file:px-3.5 file:py-2 file:text-sm file:font-medium file:text-background"
              />
            )}

            <textarea
              value={explanation}
              onChange={(e) => setExplanation(e.target.value)}
              rows={3}
              placeholder="Anything you want to explain about your submission (optional)"
              className="rounded-lg border border-border bg-surface px-3 py-2 text-sm text-text outline-none focus:border-accent"
            />

            {error && <p className="text-sm text-red-400">{error}</p>}

            <button
              type="button"
              onClick={handleSubmit}
              disabled={
                submitting ||
                (type === 'code' && !codeContent) ||
                (type === 'link' && !linkUrl) ||
                (type === 'file' && !file && !submission?.file_path)
              }
              className="w-fit rounded-lg bg-accent px-5 py-2.5 font-medium text-background hover:opacity-90 disabled:opacity-50"
            >
              {submitting ? 'Submitting…' : submission ? 'Resubmit' : 'Submit assignment'}
            </button>
          </div>
        )}
      </div>
    </div>
  )
}
