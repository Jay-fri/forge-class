import { lazy, Suspense, useEffect, useState } from 'react'
import { Link, Navigate, useParams } from 'react-router-dom'
import { motion } from 'framer-motion'
import { supabase } from '../lib/supabase'
import type { Database, SubmissionType } from '../lib/database.types'
import { Markdown } from '../components/content/Markdown'
import { Toast } from '../components/Toast'
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
  const [submittedToast, setSubmittedToast] = useState<string | null>(null)

  useEffect(() => {
    if (!submittedToast) return
    const timer = setTimeout(() => setSubmittedToast(null), 4000)
    return () => clearTimeout(timer)
  }, [submittedToast])

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

      const wasResubmit = Boolean(submission)
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
      setSubmittedToast(wasResubmit ? 'Resubmitted' : 'Submission received')
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
    <div className="student-view min-h-svh bg-background">
      <Toast message={submittedToast} icon={<CheckCircleIcon className="text-success" size={18} />} />

      <header className="border-b border-border bg-background/95 px-4 py-3 backdrop-blur">
        <div className="mx-auto flex max-w-4xl items-center gap-3">
          <Link to="/learn" className="forge-icon-tile h-9 w-9 rounded-lg text-text-secondary hover:text-text">
            <ChevronLeftIcon size={22} />
          </Link>
          <div><p className="forge-panel-label">Module assignment</p><h1 className="truncate font-heading text-xl text-text">{assignment.title}</h1></div>
        </div>
      </header>

      <div className="mx-auto grid max-w-6xl gap-5 px-4 py-6 sm:px-6 lg:grid-cols-[.85fr_1.15fr] lg:px-10">
       <div className="forge-card h-fit p-5 sm:p-7"><p className="page-kicker">The brief</p><div className="mt-4"><Markdown>{assignment.spec}</Markdown></div></div>
       <div className="flex flex-col gap-5">

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
          <motion.div
            key={`${submission.status}-${submission.passed}`}
            initial={{ opacity: 0, scale: 0.96, y: -6 }}
            animate={{ opacity: 1, scale: 1, y: 0 }}
            transition={{ type: 'spring', damping: 22, stiffness: 300 }}
            className={`forge-card rounded-xl px-4 py-3 ${
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
                ` · ${submission.passed ? 'Passed' : 'Needs work'}`}
              {submission.score !== null && ` · Score: ${submission.score}`}
            </p>
            {submission.feedback && (
              <p className="mt-2 text-sm text-text-secondary">{submission.feedback}</p>
            )}
          </motion.div>
        )}

        {canEdit && (
          <div className="forge-card flex flex-col gap-4 p-5 sm:p-6">
            <div><p className="forge-panel-label mb-3">Your submission</p><div className="flex gap-2">
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
            </div></div>

            {type === 'code' && (
              <textarea
                value={codeContent}
                onChange={(e) => setCodeContent(e.target.value)}
                rows={10}
                placeholder="Paste your code here"
                className="forge-input font-mono text-sm"
              />
            )}
            {type === 'link' && (
              <input
                value={linkUrl}
                onChange={(e) => setLinkUrl(e.target.value)}
                placeholder="https://your-deployed-project.com"
                className="forge-input"
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
              className="forge-input text-sm"
            />

            {error && <p className="text-sm text-accent">{error}</p>}

            <button
              type="button"
              onClick={handleSubmit}
              disabled={
                submitting ||
                (type === 'code' && !codeContent) ||
                (type === 'link' && !linkUrl) ||
                (type === 'file' && !file && !submission?.file_path)
              }
              className="forge-button w-fit disabled:opacity-50"
            >
              {submitting ? 'Submitting…' : submission ? 'Resubmit' : 'Submit assignment'}
            </button>
          </div>
        )}</div>
      </div>
    </div>
  )
}
