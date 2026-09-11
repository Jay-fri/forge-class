import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'
import { supabase } from '../lib/supabase'
import type { Database } from '../lib/database.types'
import {
  BookIcon,
  CheckCircleIcon,
  LockIcon,
  MessageIcon,
  PencilIcon,
  SparkleIcon,
  SpinnerIcon,
} from '../components/icons'

type Track = Database['public']['Tables']['tracks']['Row']
type Module = Database['public']['Tables']['modules']['Row']
type Bundle = Database['public']['Tables']['bundles']['Row']

// Same contact number used on the pending-approval screen for payment
// arrangement, reused here as the general "buy a bundle" channel.
const WHATSAPP_NUMBER = '2348101593762'

function purchaseLink(trackName: string, bundleName: string | null) {
  const message = bundleName
    ? `Hi! I'd like to purchase the ${bundleName} bundle to get access to ${trackName}.`
    : `Hi! I'd like to purchase access to ${trackName}.`
  return `https://wa.me/${WHATSAPP_NUMBER}?text=${encodeURIComponent(message)}`
}

interface CatalogLesson {
  id: string
  module_id: string
  title: string
  slug: string
  order_index: number
  is_free_preview: boolean
  completed: boolean
}

interface TrackTree extends Track {
  unlocked: boolean
  unlockBundleName: string | null
  modules: (Module & {
    lessons: CatalogLesson[]
    assignmentId: string | null
  })[]
}

const levelLabel: Record<Track['level'], string> = {
  beginner: 'Beginner',
  intermediate: 'Intermediate',
  advanced: 'Advanced',
}

export function Learn() {
  const { profile } = useAuth()
  const [tracks, setTracks] = useState<TrackTree[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    async function load() {
      const {
        data: { user },
      } = await supabase.auth.getUser()

      const [{ data: trackRows }, { data: moduleRows }, { data: bundleTrackRows }, { data: bundleRows }] =
        await Promise.all([
          supabase.from('tracks').select('*').order('order_index'),
          supabase.from('modules').select('*').order('order_index'),
          supabase.from('bundle_tracks').select('bundle_id, track_id'),
          supabase.from('bundles').select('*'),
        ])

      const trackList = trackRows ?? []
      const moduleList: Module[] = moduleRows ?? []
      const bundleTracks = bundleTrackRows ?? []
      const bundles: Bundle[] = bundleRows ?? []

      const trackIds = trackList.map((t) => t.id)
      const [{ data: catalogLessons }, { data: allSections }, { data: moduleAssignments }] =
        await Promise.all([
          trackIds.length
            ? supabase.rpc('get_catalog_lessons', { p_track_ids: trackIds })
            : Promise.resolve({ data: [] }),
          supabase.from('sections').select('id, lesson_id'),
          supabase.from('assignments').select('id, module_id').not('module_id', 'is', null),
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
      const isLessonComplete = (lessonId: string) => {
        const total = sectionCountByLesson.get(lessonId) ?? 0
        return total > 0 && completedByLesson.get(lessonId) === total
      }

      const canAccessTrack = (trackId: string) => {
        const unlockBundleIds = bundleTracks.filter((bt) => bt.track_id === trackId).map((bt) => bt.bundle_id)
        if (unlockBundleIds.length === 0) return true
        return (
          profile?.approval_status === 'approved' &&
          !!profile.assigned_bundle_id &&
          unlockBundleIds.includes(profile.assigned_bundle_id)
        )
      }

      const unlockBundleName = (trackId: string) => {
        const unlockBundleIds = bundleTracks.filter((bt) => bt.track_id === trackId).map((bt) => bt.bundle_id)
        if (unlockBundleIds.length === 0) return null
        return bundles.find((b) => unlockBundleIds.includes(b.id))?.name ?? null
      }

      const tree: TrackTree[] = trackList.map((t) => ({
        ...t,
        unlocked: canAccessTrack(t.id),
        unlockBundleName: unlockBundleName(t.id),
        modules: moduleList
          .filter((m) => m.track_id === t.id)
          .map((m) => ({
            ...m,
            lessons: (catalogLessons ?? [])
              .filter((l) => l.module_id === m.id)
              .map((l) => ({ ...l, completed: isLessonComplete(l.id) })),
            assignmentId: (moduleAssignments ?? []).find((a) => a.module_id === m.id)?.id ?? null,
          })),
      }))
      setTracks(tree)
      setLoading(false)
    }
    load()
  }, [profile])

  if (loading) {
    return (
      <div className="flex justify-center py-20 text-accent">
        <SpinnerIcon className="animate-spin" size={24} />
      </div>
    )
  }

  const myTracks = tracks.filter((t) => t.unlocked)
  const otherTracks = tracks.filter((t) => !t.unlocked)

  return (
    <div className="page-frame">
      <p className="page-kicker">Track catalog</p><h1 className="page-title">Learn</h1>
      <p className="page-intro">Pick up where you left off across the tracks you have access to.</p>

      <div className="mt-8 flex flex-col gap-5">
        {myTracks.map((track) => (
          <div
            key={track.id}
            className="rounded-2xl border border-border bg-surface/40 px-4 py-5 shadow-lg shadow-black/10 sm:px-6 sm:py-6"
          >
            <div className="flex flex-wrap items-center justify-between gap-2">
              <div className="flex items-center gap-2">
                <h2 className="font-heading text-lg text-text">{track.name}</h2>
                <span className="rounded-full border border-border px-2 py-0.5 text-xs text-text-secondary">
                  {levelLabel[track.level]}
                </span>
              </div>
              <Link
                to={`/learn/discussion/${track.id}`}
                className="flex shrink-0 items-center gap-1.5 text-sm text-accent hover:underline"
              >
                <MessageIcon size={14} />
                Questions
              </Link>
            </div>
            {track.description && (
              <p className="mt-1 text-sm text-text-secondary">{track.description}</p>
            )}

            <div className="mt-5 flex flex-col gap-5 border-t border-border/70 pt-5">
              {track.modules.map((module) => (
                <div key={module.id}>
                  <p className="mb-1.5 text-xs uppercase tracking-wide text-text-secondary/70">
                    {module.name}
                  </p>
                  <div className="grid gap-2 lg:grid-cols-2">
                    {module.lessons.map((lesson) => (
                      <Link
                        key={lesson.id}
                        to={`/learn/${track.slug}/${module.slug}/${lesson.slug}`}
                        className="flex items-center gap-3 rounded-xl border border-border bg-surface px-4 py-3.5 transition-colors hover:border-accent/60 hover:bg-accent/5"
                      >
                        <span
                          className={`flex h-8 w-8 shrink-0 items-center justify-center rounded-full ${
                            lesson.completed ? 'bg-success/15 text-success' : 'bg-accent/10 text-accent'
                          }`}
                        >
                          {lesson.completed ? <CheckCircleIcon size={18} /> : <BookIcon size={16} />}
                        </span>
                        <span className="min-w-0 truncate font-medium text-text">{lesson.title}</span>
                      </Link>
                    ))}
                    {module.lessons.length === 0 && (
                      <p className="text-sm text-text-secondary">Content coming soon.</p>
                    )}
                  </div>
                  {module.assignmentId && (
                    <Link
                      to={`/learn/assignment/${module.assignmentId}`}
                      className="mt-2 flex items-center gap-2 text-sm text-accent hover:underline"
                    >
                      <PencilIcon size={14} />
                      Module assignment
                    </Link>
                  )}
                </div>
              ))}
            </div>
          </div>
        ))}

        {myTracks.length === 0 && (
          <p className="py-10 text-center text-text-secondary">
            No tracks available yet, check back soon.
          </p>
        )}
      </div>

      {otherTracks.length > 0 && (
        <>
          <h2 className="mt-12 font-heading text-xl text-text">Other courses available</h2>
          <p className="mt-1 text-sm text-text-secondary">
            Message us on WhatsApp to purchase and get access.
          </p>

          <div className="mt-5 grid gap-3 sm:grid-cols-2">
            {otherTracks.map((track) => {
              const previewLessons = track.modules
                .flatMap((m) => m.lessons.map((l) => ({ ...l, moduleSlug: m.slug })))
                .filter((l) => l.is_free_preview)
              return (
                <div key={track.id} className="rounded-2xl border border-border bg-surface/20 p-5">
                  <div className="flex items-center gap-2">
                    <LockIcon size={14} className="text-text-secondary" />
                    <h3 className="font-heading text-lg text-text">{track.name}</h3>
                    <span className="rounded-full border border-border px-2 py-0.5 text-xs text-text-secondary">
                      {levelLabel[track.level]}
                    </span>
                  </div>
                  {track.description && (
                    <p className="mt-1.5 text-sm text-text-secondary">{track.description}</p>
                  )}

                  {previewLessons.length > 0 && (
                    <div className="mt-3 flex flex-col gap-1.5">
                      {previewLessons.map((lesson) => (
                        <Link
                          key={lesson.id}
                          to={`/learn/${track.slug}/${lesson.moduleSlug}/${lesson.slug}`}
                          className="flex items-center gap-2 text-sm text-accent hover:underline"
                        >
                          <SparkleIcon size={13} />
                          Free preview: {lesson.title}
                        </Link>
                      ))}
                    </div>
                  )}

                  <a
                    href={purchaseLink(track.name, track.unlockBundleName)}
                    target="_blank"
                    rel="noreferrer"
                    className="forge-button mt-4 w-full justify-center px-4 py-2.5 text-sm"
                  >
                    {track.unlockBundleName ? `Purchase ${track.unlockBundleName}` : 'Purchase access'}
                  </a>
                </div>
              )
            })}
          </div>
        </>
      )}
    </div>
  )
}
