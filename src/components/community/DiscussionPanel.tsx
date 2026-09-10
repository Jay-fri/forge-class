import { useEffect, useState } from 'react'
import { supabase } from '../../lib/supabase'
import type { Database } from '../../lib/database.types'
import { ChevronLeftIcon, MessageIcon, ShieldIcon, SpinnerIcon, XIcon } from '../icons'

type Thread = Database['public']['Tables']['discussion_threads']['Row']
type Reply = Database['public']['Tables']['discussion_replies']['Row']
type PublicProfile = { id: string; full_name: string | null; role: string }

interface ThreadWithMeta extends Thread {
  authorName: string
  authorIsInstructor: boolean
  replyCount: number
}

interface ReplyWithMeta extends Reply {
  authorName: string
  authorIsInstructor: boolean
}

export function DiscussionPanel({
  lessonId,
  trackId,
  onClose,
}: {
  lessonId?: string
  trackId?: string
  onClose?: () => void
}) {
  const [threads, setThreads] = useState<ThreadWithMeta[]>([])
  const [loading, setLoading] = useState(true)
  const [selectedThread, setSelectedThread] = useState<ThreadWithMeta | null>(null)
  const [replies, setReplies] = useState<ReplyWithMeta[]>([])
  const [replyBody, setReplyBody] = useState('')
  const [creating, setCreating] = useState(false)
  const [draftTitle, setDraftTitle] = useState('')
  const [draftBody, setDraftBody] = useState('')
  const [saving, setSaving] = useState(false)

  async function loadThreads() {
    setLoading(true)
    const query = supabase.from('discussion_threads').select('*').order('created_at', { ascending: false })
    const { data: threadRows } = lessonId
      ? await query.eq('lesson_id', lessonId)
      : await query.eq('track_id', trackId!)

    const authorIds = [...new Set((threadRows ?? []).map((t) => t.author_id))]
    const { data: profiles } = authorIds.length
      ? await supabase.rpc('get_public_profiles', { p_ids: authorIds })
      : { data: [] as PublicProfile[] }

    const threadIds = (threadRows ?? []).map((t) => t.id)
    const { data: replyRows } = threadIds.length
      ? await supabase.from('discussion_replies').select('thread_id').in('thread_id', threadIds)
      : { data: [] as { thread_id: string }[] }

    setThreads(
      (threadRows ?? []).map((t) => {
        const author = profiles?.find((p) => p.id === t.author_id)
        return {
          ...t,
          authorName: author?.full_name ?? 'Someone',
          authorIsInstructor: author?.role === 'instructor',
          replyCount: (replyRows ?? []).filter((r) => r.thread_id === t.id).length,
        }
      }),
    )
    setLoading(false)
  }

  useEffect(() => {
    loadThreads()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [lessonId, trackId])

  async function openThread(thread: ThreadWithMeta) {
    setSelectedThread(thread)
    const [{ data: replyRows }] = await Promise.all([
      supabase.from('discussion_replies').select('*').eq('thread_id', thread.id).order('created_at'),
    ])
    const authorIds = [...new Set((replyRows ?? []).map((r) => r.author_id))]
    const { data: profiles } = authorIds.length
      ? await supabase.rpc('get_public_profiles', { p_ids: authorIds })
      : { data: [] as PublicProfile[] }
    setReplies(
      (replyRows ?? []).map((r) => {
        const author = profiles?.find((p) => p.id === r.author_id)
        return {
          ...r,
          authorName: author?.full_name ?? 'Someone',
          authorIsInstructor: author?.role === 'instructor',
        }
      }),
    )
  }

  async function createThread() {
    setSaving(true)
    const {
      data: { user },
    } = await supabase.auth.getUser()
    if (user) {
      await supabase.from('discussion_threads').insert({
        lesson_id: lessonId ?? null,
        track_id: trackId ?? null,
        author_id: user.id,
        title: draftTitle,
        body: draftBody,
      })
    }
    setSaving(false)
    setCreating(false)
    setDraftTitle('')
    setDraftBody('')
    await loadThreads()
  }

  async function sendReply() {
    if (!selectedThread || !replyBody.trim()) return
    setSaving(true)
    const {
      data: { user },
    } = await supabase.auth.getUser()
    if (user) {
      await supabase.from('discussion_replies').insert({
        thread_id: selectedThread.id,
        author_id: user.id,
        body: replyBody,
      })
    }
    setReplyBody('')
    setSaving(false)
    await openThread(selectedThread)
    await loadThreads()
  }

  return (
    <div className="flex h-full flex-col bg-background">
      <header className="flex items-center gap-2 border-b border-border px-4 py-3">
        {selectedThread ? (
          <button
            onClick={() => setSelectedThread(null)}
            className="text-text-secondary hover:text-text"
            aria-label="Back to questions"
          >
            <ChevronLeftIcon size={20} />
          </button>
        ) : (
          <MessageIcon className="text-accent" size={20} />
        )}
        <h2 className="truncate font-heading text-lg text-text">
          {selectedThread ? selectedThread.title : 'Questions'}
        </h2>
        {onClose && (
          <button
            type="button"
            onClick={onClose}
            className="ml-auto text-text-secondary hover:text-text"
            aria-label="Close"
          >
            <XIcon size={20} />
          </button>
        )}
      </header>

      <div className="flex-1 overflow-y-auto px-4 py-4">
        {loading ? (
          <div className="flex justify-center py-10 text-accent">
            <SpinnerIcon className="animate-spin" size={22} />
          </div>
        ) : selectedThread ? (
          <div className="flex flex-col gap-4">
            <div>
              <div className="flex items-center gap-1.5 text-xs text-text-secondary">
                {selectedThread.authorIsInstructor && (
                  <ShieldIcon size={12} className="text-accent" />
                )}
                {selectedThread.authorName} ·{' '}
                {new Date(selectedThread.created_at).toLocaleDateString()}
              </div>
              <p className="mt-1 whitespace-pre-wrap text-text">{selectedThread.body}</p>
            </div>

            <div className="flex flex-col gap-3 border-t border-border pt-4">
              {replies.map((r) => (
                <div key={r.id} className="rounded-lg border border-border bg-surface px-3 py-2.5">
                  <div className="flex items-center gap-1.5 text-xs text-text-secondary">
                    {r.authorIsInstructor && <ShieldIcon size={12} className="text-accent" />}
                    {r.authorName} · {new Date(r.created_at).toLocaleDateString()}
                  </div>
                  <p className="mt-1 whitespace-pre-wrap text-sm text-text">{r.body}</p>
                </div>
              ))}
              {replies.length === 0 && (
                <p className="text-sm text-text-secondary">No replies yet. Be the first.</p>
              )}
            </div>
          </div>
        ) : creating ? (
          <div className="flex flex-col gap-3">
            <input
              value={draftTitle}
              onChange={(e) => setDraftTitle(e.target.value)}
              placeholder="What's your question about?"
              className="rounded-lg border border-border bg-surface px-3 py-2 text-text outline-none focus:border-accent"
            />
            <textarea
              value={draftBody}
              onChange={(e) => setDraftBody(e.target.value)}
              rows={5}
              placeholder="Add any detail that would help someone answer."
              className="rounded-lg border border-border bg-surface px-3 py-2 text-sm text-text outline-none focus:border-accent"
            />
            <div className="flex gap-2">
              <button
                onClick={createThread}
                disabled={saving || !draftTitle.trim() || !draftBody.trim()}
                className="rounded-lg bg-accent px-4 py-2 text-sm font-medium text-background hover:opacity-90 disabled:opacity-50"
              >
                {saving ? 'Posting…' : 'Post question'}
              </button>
              <button
                onClick={() => setCreating(false)}
                className="rounded-lg border border-border px-4 py-2 text-sm text-text-secondary hover:bg-surface"
              >
                Cancel
              </button>
            </div>
          </div>
        ) : (
          <div className="flex flex-col gap-2">
            <button
              onClick={() => setCreating(true)}
              className="mb-2 w-fit rounded-full bg-accent px-4 py-2 text-sm font-medium text-background hover:opacity-90"
            >
              + Ask a question
            </button>
            {threads.map((t) => (
              <button
                key={t.id}
                onClick={() => openThread(t)}
                className="rounded-xl border border-border bg-surface px-4 py-3 text-left transition-colors hover:border-accent/40"
              >
                <p className="text-text">{t.title}</p>
                <p className="mt-0.5 flex items-center gap-1.5 text-xs text-text-secondary">
                  {t.authorIsInstructor && <ShieldIcon size={12} className="text-accent" />}
                  {t.authorName} · {t.replyCount} repl{t.replyCount === 1 ? 'y' : 'ies'}
                </p>
              </button>
            ))}
            {threads.length === 0 && (
              <p className="py-8 text-center text-text-secondary">No questions yet. Ask the first one.</p>
            )}
          </div>
        )}
      </div>

      {selectedThread && (
        <form
          onSubmit={(e) => {
            e.preventDefault()
            sendReply()
          }}
          className="flex gap-2 border-t border-border p-3"
        >
          <input
            value={replyBody}
            onChange={(e) => setReplyBody(e.target.value)}
            placeholder="Write a reply…"
            className="flex-1 rounded-lg border border-border bg-surface px-3.5 py-2.5 text-text outline-none focus:border-accent"
          />
          <button
            type="submit"
            disabled={saving || !replyBody.trim()}
            className="rounded-lg bg-accent px-4 font-medium text-background hover:opacity-90 disabled:opacity-40"
          >
            Reply
          </button>
        </form>
      )}
    </div>
  )
}
