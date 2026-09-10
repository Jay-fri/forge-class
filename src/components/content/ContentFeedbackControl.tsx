import { useState } from 'react'
import { supabase } from '../../lib/supabase'
import type { ContentFeedbackType } from '../../lib/database.types'
import { CheckCircleIcon, MessageIcon, PencilIcon } from '../icons'

export function ContentFeedbackControl({ sectionId }: { sectionId: string }) {
  const [open, setOpen] = useState<ContentFeedbackType | null>(null)
  const [note, setNote] = useState('')
  const [submitting, setSubmitting] = useState(false)
  const [sentType, setSentType] = useState<ContentFeedbackType | null>(null)

  async function submit(type: ContentFeedbackType) {
    setSubmitting(true)
    const {
      data: { user },
    } = await supabase.auth.getUser()
    if (user) {
      await supabase.from('content_feedback').insert({
        section_id: sectionId,
        user_id: user.id,
        feedback_type: type,
        note: note || null,
      })
    }
    setSubmitting(false)
    setOpen(null)
    setNote('')
    setSentType(type)
  }

  if (sentType) {
    return (
      <p className="flex items-center gap-1.5 text-sm text-text-secondary">
        <CheckCircleIcon size={14} className="text-success" />
        Thanks, noted.
      </p>
    )
  }

  if (open) {
    return (
      <div className="forge-card flex flex-col gap-2 p-3">
        <textarea
          value={note}
          onChange={(e) => setNote(e.target.value)}
          placeholder={
            open === 'confusing' ? 'What was confusing? (optional)' : 'What was the typo? (optional)'
          }
          rows={2}
          autoFocus
          className="forge-input text-sm"
        />
        <div className="flex gap-2">
          <button
            type="button"
            onClick={() => submit(open)}
            disabled={submitting}
            className="forge-button min-h-0 px-3 py-1.5 text-sm disabled:opacity-60"
          >
            {submitting ? 'Sending…' : 'Send'}
          </button>
          <button
            type="button"
            onClick={() => setOpen(null)}
            className="forge-button-secondary min-h-0 px-3 py-1.5 text-sm text-text-secondary"
          >
            Cancel
          </button>
        </div>
      </div>
    )
  }

  return (
    <div className="flex flex-wrap gap-x-4 gap-y-2 border-t border-border pt-4">
      <button
        type="button"
        onClick={() => setOpen('confusing')}
        className="flex items-center gap-1.5 text-sm text-text-secondary hover:text-text"
      >
        <MessageIcon size={14} />
        This was confusing
      </button>
      <button
        type="button"
        onClick={() => setOpen('typo')}
        className="flex items-center gap-1.5 text-sm text-text-secondary hover:text-text"
      >
        <PencilIcon size={14} />
        Found a typo
      </button>
    </div>
  )
}
