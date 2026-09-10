import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'
import { supabase } from '../lib/supabase'
import { generateCertificate, downloadBlob } from '../lib/certificate'
import type { Database } from '../lib/database.types'
import {
  BookmarkIcon,
  FlameIcon,
  PencilIcon,
  SpinnerIcon,
  TrophyIcon,
} from '../components/icons'

type Badge = Database['public']['Tables']['badges']['Row']
type Track = Database['public']['Tables']['tracks']['Row']
type Bookmark = Database['public']['Tables']['section_bookmarks']['Row']
type Submission = Database['public']['Tables']['submissions']['Row']
type Assignment = Database['public']['Tables']['assignments']['Row']

interface TrackProgress extends Track {
  totalSections: number
  completedSections: number
}

interface BookmarkWithContext extends Bookmark {
  sectionTitle: string | null
  lessonSlug: string
  moduleSlug: string
  trackSlug: string
}

interface SubmissionWithAssignment extends Submission {
  assignmentTitle: string
}

export function Progress() {
  const { profile } = useAuth()
  const [loading, setLoading] = useState(true)
  const [streak, setStreak] = useState({ current: 0, longest: 0 })
  const [badges, setBadges] = useState<Badge[]>([])
  const [earnedBadgeIds, setEarnedBadgeIds] = useState<Set<string>>(new Set())
  const [tracks, setTracks] = useState<TrackProgress[]>([])
  const [bookmarks, setBookmarks] = useState<BookmarkWithContext[]>([])
  const [submissions, setSubmissions] = useState<SubmissionWithAssignment[]>([])
  const [downloadingTrack, setDownloadingTrack] = useState<string | null>(null)

  useEffect(() => {
    async function load() {
      const {
        data: { user },
      } = await supabase.auth.getUser()
      if (!user) return

      const [
        { data: streakRow },
        { data: allBadges },
        { data: earnedBadges },
        { data: trackRows },
        { data: moduleRows },
        { data: lessonRows },
        { data: sectionRows },
        { data: progressRows },
        { data: bookmarkRows },
        { data: submissionRows },
      ] = await Promise.all([
        supabase.from('streaks').select('current_streak, longest_streak').eq('user_id', user.id).maybeSingle(),
        supabase.from('badges').select('*').order('created_at'),
        supabase.from('user_badges').select('badge_id').eq('user_id', user.id),
        supabase.from('tracks').select('*').order('order_index'),
        supabase.from('modules').select('id, track_id'),
        supabase.from('lessons').select('id, module_id'),
        supabase.from('sections').select('id, lesson_id, title'),
        supabase
          .from('user_progress')
          .select('section_id')
          .eq('user_id', user.id)
          .eq('status', 'completed'),
        supabase
          .from('section_bookmarks')
          .select('*')
          .eq('user_id', user.id)
          .order('created_at', { ascending: false }),
        supabase
          .from('submissions')
          .select('*')
          .eq('student_id', user.id)
          .order('submitted_at', { ascending: false }),
      ])

      setStreak(
        streakRow
          ? { current: streakRow.current_streak, longest: streakRow.longest_streak }
          : { current: 0, longest: 0 },
      )
      setBadges(allBadges ?? [])
      setEarnedBadgeIds(new Set((earnedBadges ?? []).map((b) => b.badge_id)))

      const modules = moduleRows ?? []
      const lessons = lessonRows ?? []
      const sections = sectionRows ?? []
      const completedIds = new Set((progressRows ?? []).map((p) => p.section_id))

      const lessonIdsByTrack = new Map<string, Set<string>>()
      for (const m of modules) {
        const lessonIds = lessons.filter((l) => l.module_id === m.id).map((l) => l.id)
        const set = lessonIdsByTrack.get(m.track_id) ?? new Set<string>()
        lessonIds.forEach((id) => set.add(id))
        lessonIdsByTrack.set(m.track_id, set)
      }

      setTracks(
        (trackRows ?? []).map((t) => {
          const lessonIds = lessonIdsByTrack.get(t.id) ?? new Set()
          const trackSections = sections.filter((s) => lessonIds.has(s.lesson_id))
          return {
            ...t,
            totalSections: trackSections.length,
            completedSections: trackSections.filter((s) => completedIds.has(s.id)).length,
          }
        }),
      )

      // Resolve each bookmark's section back to its track/module/lesson slugs.
      const { data: lessonSlugs } = await supabase.from('lessons').select('id, slug, module_id')
      const { data: moduleSlugs } = await supabase.from('modules').select('id, slug, track_id')
      const { data: trackSlugs } = await supabase.from('tracks').select('id, slug')
      setBookmarks(
        (bookmarkRows ?? []).flatMap((bm) => {
          const section = sections.find((s) => s.id === bm.section_id)
          const lesson = lessonSlugs?.find((l) => l.id === section?.lesson_id)
          const mod = moduleSlugs?.find((m) => m.id === lesson?.module_id)
          const track = trackSlugs?.find((t) => t.id === mod?.track_id)
          if (!section || !lesson || !mod || !track) return []
          return [
            {
              ...bm,
              sectionTitle: section.title,
              lessonSlug: lesson.slug,
              moduleSlug: mod.slug,
              trackSlug: track.slug,
            },
          ]
        }),
      )

      if ((submissionRows ?? []).length > 0) {
        const assignmentIds = [...new Set((submissionRows ?? []).map((s) => s.assignment_id))]
        const { data: assignmentRows } = await supabase
          .from('assignments')
          .select('id, title')
          .in('id', assignmentIds)
        setSubmissions(
          (submissionRows ?? []).map((s) => ({
            ...s,
            assignmentTitle:
              (assignmentRows as Pick<Assignment, 'id' | 'title'>[] | null)?.find(
                (a) => a.id === s.assignment_id,
              )?.title ?? 'Assignment',
          })),
        )
      }

      setLoading(false)
    }
    load()
  }, [])

  async function handleDownloadCertificate(track: TrackProgress) {
    setDownloadingTrack(track.id)
    try {
      const blob = await generateCertificate({
        studentName: profile?.full_name ?? 'Forge Student',
        trackName: track.name,
        date: new Date(),
      })
      downloadBlob(blob, `forge-certificate-${track.slug}.png`)
    } finally {
      setDownloadingTrack(null)
    }
  }

  if (loading) {
    return (
      <div className="flex justify-center py-20 text-accent">
        <SpinnerIcon className="animate-spin" size={24} />
      </div>
    )
  }

  return (
    <div className="page-frame">
      <p className="page-kicker">Your record</p><h1 className="page-title">Progress</h1>

      <div className="mt-7 grid grid-cols-2 gap-3 lg:max-w-2xl">
        <div className="forge-card px-4 py-5">
          <FlameIcon className={streak.current > 0 ? 'text-accent' : 'text-text-secondary'} size={22} />
          <p className="mt-2 text-2xl font-medium text-text">{streak.current}</p>
          <p className="text-sm text-text-secondary">Day streak</p>
        </div>
        <div className="forge-card px-4 py-5">
          <TrophyIcon className="text-accent" size={22} />
          <p className="mt-2 text-2xl font-medium text-text">{earnedBadgeIds.size}</p>
          <p className="text-sm text-text-secondary">Badges earned</p>
        </div>
      </div>

      <h2 className="mt-10 font-heading text-2xl text-text">Badges</h2>
      <div className="mt-3 grid grid-cols-2 gap-3 sm:grid-cols-3">
        {badges.map((badge) => {
          const earned = earnedBadgeIds.has(badge.id)
          return (
            <div
              key={badge.id}
              title={badge.description}
              className={`flex min-h-32 flex-col items-center justify-center gap-1.5 rounded-2xl border px-3 py-4 text-center ${
                earned ? 'border-accent/30 bg-accent/5' : 'border-border bg-surface opacity-50'
              }`}
            >
              <TrophyIcon className={earned ? 'text-accent' : 'text-text-secondary'} size={24} />
              <span className="text-sm text-text">{badge.name}</span>
            </div>
          )
        })}
      </div>

      <h2 className="mt-10 font-heading text-2xl text-text">Tracks</h2>
      <div className="mt-3 flex flex-col gap-3">
        {tracks.map((track) => {
          const pct =
            track.totalSections > 0
              ? Math.round((track.completedSections / track.totalSections) * 100)
              : 0
          const complete = track.totalSections > 0 && track.completedSections === track.totalSections
          return (
            <div key={track.id} className="forge-card px-4 py-4 sm:px-5">
              <div className="flex items-center justify-between gap-3">
                <p className="min-w-0 truncate font-medium text-text">{track.name}</p>
                <span className="shrink-0 text-sm text-text-secondary">{pct}%</span>
              </div>
              <div className="mt-2 h-1.5 rounded-full bg-border">
                <div
                  className={`h-full rounded-full ${complete ? 'bg-success' : 'bg-accent'}`}
                  style={{ width: `${pct}%` }}
                />
              </div>
              {complete && (
                <button
                  type="button"
                  onClick={() => handleDownloadCertificate(track)}
                  disabled={downloadingTrack === track.id}
                  className="mt-3 text-sm text-accent hover:underline disabled:opacity-60"
                >
                  {downloadingTrack === track.id ? 'Generating…' : 'Download certificate'}
                </button>
              )}
            </div>
          )
        })}
      </div>

      {bookmarks.length > 0 && (
        <>
          <h2 className="mt-10 font-heading text-2xl text-text">Bookmarks & notes</h2>
          <div className="mt-3 flex flex-col gap-2">
            {bookmarks.map((bm) => (
              <Link
                key={bm.id}
                to={`/learn/${bm.trackSlug}/${bm.moduleSlug}/${bm.lessonSlug}`}
                className="forge-card flex items-start gap-3 px-4 py-3.5 transition-colors hover:border-accent/60"
              >
                <BookmarkIcon className="mt-0.5 shrink-0 text-accent" size={16} filled />
                <div className="min-w-0">
                  <p className="truncate text-sm text-text">{bm.sectionTitle ?? 'Untitled section'}</p>
                  {bm.note && <p className="mt-0.5 wrap-break-word text-xs text-text-secondary">{bm.note}</p>}
                </div>
              </Link>
            ))}
          </div>
        </>
      )}

      {submissions.length > 0 && (
        <>
          <h2 className="mt-10 font-heading text-2xl text-text">Assignment history</h2>
          <div className="mt-3 flex flex-col gap-2">
            {submissions.map((s) => (
              <Link
                key={s.id}
                to={`/learn/assignment/${s.assignment_id}`}
                className="forge-card flex items-center justify-between gap-3 px-4 py-3.5 transition-colors hover:border-accent/60"
              >
                <div className="flex min-w-0 items-center gap-3">
                  <PencilIcon className="shrink-0 text-accent" size={16} />
                  <div className="min-w-0">
                    <p className="truncate text-sm text-text">{s.assignmentTitle}</p>
                    {s.status === 'graded' && s.feedback && (
                      <p className="mt-0.5 truncate text-xs text-text-secondary">{s.feedback}</p>
                    )}
                  </div>
                </div>
                <span
                  className={`shrink-0 rounded-full border px-2.5 py-1 text-xs capitalize ${
                    s.status === 'graded'
                      ? s.passed
                        ? 'border-success/40 text-success'
                        : 'border-border text-text-secondary'
                      : 'border-accent/40 text-accent'
                  }`}
                >
                  {s.status === 'graded'
                    ? s.passed === true
                      ? 'Passed'
                      : s.passed === false
                        ? 'Needs work'
                        : 'Graded'
                    : s.status.replace('_', ' ')}
                </span>
              </Link>
            ))}
          </div>
        </>
      )}
    </div>
  )
}
