import { useEffect, useState } from 'react'
import { supabase } from '../../lib/supabase'
import type { Database } from '../../lib/database.types'
import { MessageIcon, ShieldIcon, SpinnerIcon } from '../../components/icons'

type Thread = Database['public']['Tables']['discussion_threads']['Row']
type Reply = Database['public']['Tables']['discussion_replies']['Row']

interface ThreadRow extends Thread {
  authorName: string
  contextLabel: string
  replyCount: number
}

interface ReplyRow extends Reply {
  authorName: string
  authorIsInstructor: boolean
}

export function Discussions() {
  const [threads, setThreads] = useState<ThreadRow[]>([])
  const [loading, setLoading] = useState(true)
  const [selected, setSelected] = useState<ThreadRow | null>(null)
  const [replies, setReplies] = useState<ReplyRow[]>([])
  const [replyBody, setReplyBody] = useState('')
  const [saving, setSaving] = useState(false)

  async function load() {
    setLoading(true)
    const [
      { data: threadRows },
      { data: profiles },
      { data: lessons },
      { data: tracks },
      { data: replyRows },
    ] = await Promise.all([
      supabase.from('discussion_threads').select('*').order('created_at', { ascending: false }),
      supabase.from('profiles').select('id, full_name, role'),
      supabase.from('lessons').select('id, title'),
      supabase.from('tracks').select('id, name'),
      supabase.from('discussion_replies').select('thread_id'),
    ])
    setThreads(
      (threadRows ?? []).map((t) => {
        const author = profiles?.find((p) => p.id === t.author_id)
        const contextLabel = t.lesson_id
          ? (lessons?.find((l) => l.id === t.lesson_id)?.title ?? 'Lesson')
          : (tracks?.find((tr) => tr.id === t.track_id)?.name ?? 'Track')
        return {
          ...t,
          authorName: author?.full_name ?? 'Someone',
          contextLabel,
          replyCount: (replyRows ?? []).filter((r) => r.thread_id === t.id).length,
        }
      }),
    )
    setLoading(false)
  }

  useEffect(() => {
    load()
  }, [])

  async function openThread(thread: ThreadRow) {
    setSelected(thread)
    const { data: replyRows } = await supabase
      .from('discussion_replies')
      .select('*')
      .eq('thread_id', thread.id)
      .order('created_at')
    const authorIds = [...new Set((replyRows ?? []).map((r) => r.author_id))]
    const { data: profiles } = authorIds.length
      ? await supabase.from('profiles').select('id, full_name, role').in('id', authorIds)
      : { data: [] }
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

  async function sendReply() {
    if (!selected || !replyBody.trim()) return
    setSaving(true)
    const {
      data: { user },
    } = await supabase.auth.getUser()
    if (user) {
      await supabase.from('discussion_replies').insert({
        thread_id: selected.id,
        author_id: user.id,
        body: replyBody,
      })
    }
    setReplyBody('')
    setSaving(false)
    await openThread(selected)
    await load()
  }

  if (loading) {
    return (
      <div className="flex justify-center py-20 text-accent">
        <SpinnerIcon className="animate-spin" size={24} />
      </div>
    )
  }

  if (selected) {
    return (
      <div className="px-6 py-8">
        <button onClick={() => setSelected(null)} className="text-sm text-text-secondary hover:text-text">
          ← Back to questions
        </button>
        <h1 className="mt-3 font-heading text-2xl text-text">{selected.title}</h1>
        <p className="text-sm text-text-secondary">
          {selected.authorName} · {selected.contextLabel}
        </p>
        <p className="mt-3 max-w-2xl whitespace-pre-wrap text-text">{selected.body}</p>

        <div className="mt-6 flex max-w-2xl flex-col gap-3">
          {replies.map((r) => (
            <div key={r.id} className="rounded-lg border border-border bg-surface px-3 py-2.5">
              <div className="flex items-center gap-1.5 text-xs text-text-secondary">
                {r.authorIsInstructor && <ShieldIcon size={12} className="text-accent" />}
                {r.authorName} · {new Date(r.created_at).toLocaleDateString()}
              </div>
              <p className="mt-1 whitespace-pre-wrap text-sm text-text">{r.body}</p>
            </div>
          ))}
          {replies.length === 0 && <p className="text-text-secondary">No replies yet.</p>}
        </div>

        <div className="mt-4 flex max-w-2xl gap-2">
          <input
            value={replyBody}
            onChange={(e) => setReplyBody(e.target.value)}
            placeholder="Write a reply…"
            className="flex-1 rounded-lg border border-border bg-surface px-3.5 py-2.5 text-text outline-none focus:border-accent"
          />
          <button
            onClick={sendReply}
            disabled={saving || !replyBody.trim()}
            className="rounded-lg bg-accent px-4 font-medium text-background hover:opacity-90 disabled:opacity-40"
          >
            Reply
          </button>
        </div>
      </div>
    )
  }

  return (
    <div className="px-6 py-8">
      <h1 className="font-heading text-2xl text-text">Questions</h1>
      <p className="mt-1 text-text-secondary">Every question asked across lessons and tracks.</p>

      <div className="mt-6 flex flex-col gap-2">
        {threads.map((t) => (
          <button
            key={t.id}
            onClick={() => openThread(t)}
            className="flex items-center justify-between gap-3 rounded-xl border border-border bg-surface px-4 py-3 text-left transition-colors hover:border-accent/40"
          >
            <div className="flex items-start gap-3">
              <MessageIcon className="mt-0.5 shrink-0 text-accent" size={16} />
              <div>
                <p className="text-text">{t.title}</p>
                <p className="text-sm text-text-secondary">
                  {t.authorName} · {t.contextLabel}
                </p>
              </div>
            </div>
            <span className="shrink-0 text-sm text-text-secondary">
              {t.replyCount} repl{t.replyCount === 1 ? 'y' : 'ies'}
            </span>
          </button>
        ))}
        {threads.length === 0 && (
          <p className="py-10 text-center text-text-secondary">No questions asked yet.</p>
        )}
      </div>
    </div>
  )
}
