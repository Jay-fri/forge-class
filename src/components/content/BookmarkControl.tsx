import { useEffect, useState } from 'react'
import { supabase } from '../../lib/supabase'
import { BookmarkIcon } from '../icons'

export function BookmarkControl({ sectionId }: { sectionId: string }) {
  const [bookmarked, setBookmarked] = useState(false)
  const [note, setNote] = useState('')
  const [editingNote, setEditingNote] = useState(false)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    let active = true
    async function load() {
      const {
        data: { user },
      } = await supabase.auth.getUser()
      if (!user) return
      const { data } = await supabase
        .from('section_bookmarks')
        .select('note')
        .eq('user_id', user.id)
        .eq('section_id', sectionId)
        .maybeSingle()
      if (!active) return
      setBookmarked(Boolean(data))
      setNote(data?.note ?? '')
      setLoading(false)
    }
    load()
    return () => {
      active = false
    }
  }, [sectionId])

  async function toggle() {
    const {
      data: { user },
    } = await supabase.auth.getUser()
    if (!user) return
    if (bookmarked) {
      await supabase
        .from('section_bookmarks')
        .delete()
        .eq('user_id', user.id)
        .eq('section_id', sectionId)
      setBookmarked(false)
      setNote('')
      setEditingNote(false)
    } else {
      await supabase.from('section_bookmarks').insert({ user_id: user.id, section_id: sectionId })
      setBookmarked(true)
    }
  }

  async function saveNote() {
    const {
      data: { user },
    } = await supabase.auth.getUser()
    if (!user) return
    await supabase
      .from('section_bookmarks')
      .upsert(
        { user_id: user.id, section_id: sectionId, note: note || null },
        { onConflict: 'user_id,section_id' },
      )
    setEditingNote(false)
  }

  if (loading) return null

  return (
    <div className="flex flex-col gap-2 border-t border-border pt-5">
      <div className="flex flex-wrap items-center gap-x-4 gap-y-2">
        <button
          type="button"
          onClick={toggle}
          className={`flex items-center gap-1.5 text-sm ${
            bookmarked ? 'text-accent' : 'text-text-secondary hover:text-text'
          }`}
        >
          <BookmarkIcon size={16} filled={bookmarked} />
          {bookmarked ? 'Bookmarked' : 'Bookmark this'}
        </button>
        {bookmarked && !editingNote && (
          <button
            type="button"
            onClick={() => setEditingNote(true)}
            className="text-sm text-text-secondary hover:text-text"
          >
            {note ? 'Edit note' : '+ Add a note'}
          </button>
        )}
      </div>

      {bookmarked && editingNote && (
        <div className="flex flex-col gap-2">
          <textarea
            value={note}
            onChange={(e) => setNote(e.target.value)}
            placeholder="Personal note (only visible to you)"
            rows={2}
            autoFocus
            className="forge-input text-sm"
          />
          <div className="flex gap-2">
            <button
              type="button"
              onClick={saveNote}
              className="forge-button min-h-0 w-fit px-3 py-1.5 text-sm"
            >
              Save
            </button>
            <button
              type="button"
              onClick={() => setEditingNote(false)}
              className="forge-button-secondary min-h-0 w-fit px-3 py-1.5 text-sm text-text-secondary"
            >
              Cancel
            </button>
          </div>
        </div>
      )}

      {bookmarked && !editingNote && note && (
        <p className="text-sm text-text-secondary">{note}</p>
      )}
    </div>
  )
}
