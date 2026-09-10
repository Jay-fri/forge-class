import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'
import { supabase } from '../lib/supabase'
import type { Database } from '../lib/database.types'
import { BookIcon, FlameIcon, SpinnerIcon, TrophyIcon } from '../components/icons'

type Module = Database['public']['Tables']['modules']['Row']
type Lesson = Database['public']['Tables']['lessons']['Row']
type Badge = Database['public']['Tables']['badges']['Row']

interface ContinueTarget {
  trackSlug: string
  moduleSlug: string
  lesson: Lesson
}

export function Home() {
  const { profile } = useAuth()
  const [loading, setLoading] = useState(true)
  const [streak, setStreak] = useState<{ current: number; longest: number } | null>(null)
  const [continueTarget, setContinueTarget] = useState<ContinueTarget | null>(null)
  const [recentBadges, setRecentBadges] = useState<Badge[]>([])
  const [allCaughtUp, setAllCaughtUp] = useState(false)

  useEffect(() => {
    async function load() {
      const {
        data: { user },
      } = await supabase.auth.getUser()
      if (!user) return

      const [{ data: streakRow }, { data: badgeRows }] = await Promise.all([
        supabase.from('streaks').select('current_streak, longest_streak').eq('user_id', user.id).maybeSingle(),
        supabase
          .from('user_badges')
          .select('badges(*)')
          .eq('user_id', user.id)
          .order('earned_at', { ascending: false })
          .limit(3),
      ])
      setStreak(
        streakRow
          ? { current: streakRow.current_streak, longest: streakRow.longest_streak }
          : { current: 0, longest: 0 },
      )
      setRecentBadges(
        ((badgeRows ?? []) as unknown as { badges: Badge }[]).map((b) => b.badges).filter(Boolean),
      )

      const [
        { data: tracks },
        { data: modules },
        { data: lessons },
        { data: sections },
        { data: progress },
      ] = await Promise.all([
        supabase.from('tracks').select('*').order('order_index'),
        supabase.from('modules').select('*').order('order_index'),
        supabase.from('lessons').select('*').order('order_index'),
        supabase.from('sections').select('id, lesson_id'),
        supabase
          .from('user_progress')
          .select('section_id, completed_at')
          .eq('user_id', user.id)
          .eq('status', 'completed')
          .order('completed_at', { ascending: false }),
      ])

      const trackList = tracks ?? []
      const moduleList: Module[] = modules ?? []
      const lessonList: Lesson[] = lessons ?? []
      const sectionList = sections ?? []
      const completedSectionIds = new Set((progress ?? []).map((p) => p.section_id))

      const sectionsByLesson = new Map<string, string[]>()
      for (const s of sectionList) {
        sectionsByLesson.set(s.lesson_id, [...(sectionsByLesson.get(s.lesson_id) ?? []), s.id])
      }
      const isLessonComplete = (lessonId: string) => {
        const ids = sectionsByLesson.get(lessonId) ?? []
        return ids.length > 0 && ids.every((id) => completedSectionIds.has(id))
      }

      // Ordered lesson sequence across the whole curriculum (track -> module -> lesson order).
      const orderedLessons: ContinueTarget[] = []
      for (const track of trackList) {
        for (const module of moduleList.filter((m) => m.track_id === track.id)) {
          for (const lesson of lessonList.filter((l) => l.module_id === module.id)) {
            orderedLessons.push({ trackSlug: track.slug, moduleSlug: module.slug, lesson })
          }
        }
      }

      if (orderedLessons.length === 0) {
        setLoading(false)
        return
      }

      // Resume at the most recently-touched incomplete lesson, or the next
      // incomplete one after it, or the very first lesson for a new student.
      const lastCompletedSectionId = progress?.[0]?.section_id
      const lastLessonId = lastCompletedSectionId
        ? sectionList.find((s) => s.id === lastCompletedSectionId)?.lesson_id
        : undefined
      const lastIndex = lastLessonId
        ? orderedLessons.findIndex((t) => t.lesson.id === lastLessonId)
        : -1

      const searchFrom = lastIndex === -1 ? 0 : lastIndex
      const next = orderedLessons
        .slice(searchFrom)
        .find((t) => !isLessonComplete(t.lesson.id))

      if (next) {
        setContinueTarget(next)
      } else {
        const anyIncomplete = orderedLessons.find((t) => !isLessonComplete(t.lesson.id))
        if (anyIncomplete) setContinueTarget(anyIncomplete)
        else setAllCaughtUp(true)
      }

      setLoading(false)
    }
    load()
  }, [])

  return (
    <div className="px-5 py-6">
      <h1 className="font-heading text-2xl text-text">
        Welcome, {profile?.full_name?.split(' ')[0] ?? 'there'}
      </h1>

      {loading ? (
        <div className="flex justify-center py-16 text-accent">
          <SpinnerIcon className="animate-spin" size={24} />
        </div>
      ) : (
        <div className="mt-6 flex flex-col gap-4">
          <div className="flex items-center gap-3 rounded-xl border border-border bg-surface px-4 py-3">
            <FlameIcon className={streak && streak.current > 0 ? 'text-accent' : 'text-text-secondary'} size={22} />
            <div>
              <p className="font-medium text-text">
                {streak?.current ?? 0} day{streak?.current === 1 ? '' : 's'} streak
              </p>
              {streak && streak.longest > streak.current && (
                <p className="text-xs text-text-secondary">Best: {streak.longest} days</p>
              )}
            </div>
          </div>

          {continueTarget && (
            <Link
              to={`/learn/${continueTarget.trackSlug}/${continueTarget.moduleSlug}/${continueTarget.lesson.slug}`}
              className="flex items-center gap-3 rounded-xl border border-accent/30 bg-accent/5 px-4 py-4 transition-colors hover:border-accent/50"
            >
              <span className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-accent/10 text-accent">
                <BookIcon size={18} />
              </span>
              <div>
                <p className="text-xs uppercase tracking-wide text-accent">Continue learning</p>
                <p className="font-medium text-text">{continueTarget.lesson.title}</p>
              </div>
            </Link>
          )}

          {allCaughtUp && (
            <div className="rounded-xl border border-success/30 bg-success/5 px-4 py-4 text-text">
              You're all caught up. New lessons will show up here as they're added.
            </div>
          )}

          {recentBadges.length > 0 && (
            <div>
              <p className="mb-2 text-xs uppercase tracking-wide text-text-secondary/70">
                Recent badges
              </p>
              <div className="flex gap-3">
                {recentBadges.map((badge) => (
                  <div
                    key={badge.id}
                    title={badge.description}
                    className="flex flex-col items-center gap-1.5 rounded-xl border border-border bg-surface px-3 py-3 text-center"
                  >
                    <TrophyIcon className="text-accent" size={20} />
                    <span className="text-xs text-text-secondary">{badge.name}</span>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>
      )}
    </div>
  )
}
