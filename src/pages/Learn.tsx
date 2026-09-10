import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { supabase } from '../lib/supabase'
import type { Database } from '../lib/database.types'
import { BookIcon, CheckCircleIcon, SpinnerIcon } from '../components/icons'

type Track = Database['public']['Tables']['tracks']['Row']
type Module = Database['public']['Tables']['modules']['Row']
type Lesson = Database['public']['Tables']['lessons']['Row']

interface TrackTree extends Track {
  modules: (Module & { lessons: (Lesson & { completed: boolean })[] })[]
}

export function Learn() {
  const [tracks, setTracks] = useState<TrackTree[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    async function load() {
      const {
        data: { user },
      } = await supabase.auth.getUser()

      const [{ data: trackRows }, { data: moduleRows }, { data: lessonRows }, { data: allSections }] =
        await Promise.all([
          supabase.from('tracks').select('*').order('order_index'),
          supabase.from('modules').select('*').order('order_index'),
          supabase.from('lessons').select('*').order('order_index'),
          supabase.from('sections').select('id, lesson_id'),
        ])

      const { data: progressRows } = user
        ? await supabase
            .from('user_progress')
            .select('section_id, status')
            .eq('user_id', user.id)
            .eq('status', 'completed')
        : { data: [] }

      const completedSectionIds = new Set((progressRows ?? []).map((p) => p.section_id))

      const sectionCountByLesson = new Map<string, number>()
      const completedByLesson = new Map<string, number>()
      for (const s of allSections ?? []) {
        sectionCountByLesson.set(s.lesson_id, (sectionCountByLesson.get(s.lesson_id) ?? 0) + 1)
        if (completedSectionIds.has(s.id)) {
          completedByLesson.set(s.lesson_id, (completedByLesson.get(s.lesson_id) ?? 0) + 1)
        }
      }

      // A lesson only counts as completed once every one of its sections is.
      const completedLessonIds = new Set<string>()
      for (const [lessonId, total] of sectionCountByLesson) {
        if (total > 0 && completedByLesson.get(lessonId) === total) completedLessonIds.add(lessonId)
      }

      const tree: TrackTree[] = (trackRows ?? []).map((t) => ({
        ...t,
        modules: (moduleRows ?? [])
          .filter((m) => m.track_id === t.id)
          .map((m) => ({
            ...m,
            lessons: (lessonRows ?? [])
              .filter((l) => l.module_id === m.id)
              .map((l) => ({ ...l, completed: completedLessonIds.has(l.id) })),
          })),
      }))
      setTracks(tree)
      setLoading(false)
    }
    load()
  }, [])

  if (loading) {
    return (
      <div className="flex justify-center py-20 text-accent">
        <SpinnerIcon className="animate-spin" size={24} />
      </div>
    )
  }

  return (
    <div className="px-5 py-6">
      <h1 className="font-heading text-2xl text-text">Learn</h1>
      <p className="mt-1 text-text-secondary">Pick up where you left off, or start something new.</p>

      <div className="mt-6 flex flex-col gap-6">
        {tracks.map((track) => (
          <div key={track.id}>
            <h2 className="font-heading text-lg text-text">{track.name}</h2>
            {track.description && (
              <p className="mt-0.5 text-sm text-text-secondary">{track.description}</p>
            )}

            <div className="mt-3 flex flex-col gap-4">
              {track.modules.map((module) => (
                <div key={module.id}>
                  <p className="mb-1.5 text-xs uppercase tracking-wide text-text-secondary/70">
                    {module.name}
                  </p>
                  <div className="grid gap-2 sm:grid-cols-2">
                    {module.lessons.map((lesson) => (
                      <Link
                        key={lesson.id}
                        to={`/learn/${track.slug}/${module.slug}/${lesson.slug}`}
                        className="flex items-center gap-3 rounded-xl border border-border bg-surface px-4 py-3 transition-colors hover:border-accent/40"
                      >
                        <span
                          className={`flex h-8 w-8 shrink-0 items-center justify-center rounded-full ${
                            lesson.completed
                              ? 'bg-success/15 text-success'
                              : 'bg-accent/10 text-accent'
                          }`}
                        >
                          {lesson.completed ? (
                            <CheckCircleIcon size={18} />
                          ) : (
                            <BookIcon size={16} />
                          )}
                        </span>
                        <span className="font-medium text-text">{lesson.title}</span>
                      </Link>
                    ))}
                  </div>
                </div>
              ))}
            </div>
          </div>
        ))}

        {tracks.length === 0 && (
          <p className="py-10 text-center text-text-secondary">
            No tracks available yet, check back soon.
          </p>
        )}
      </div>
    </div>
  )
}
