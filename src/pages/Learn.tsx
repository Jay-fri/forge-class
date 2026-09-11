import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'
import { supabase } from '../lib/supabase'
import type { Database } from '../lib/database.types'
import {
  BookIcon,
  CheckCircleIcon,
  ChevronRightIcon,
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
  unlockBundleName: string | null
  complete: boolean
  modules: (Module & {
    lessons: CatalogLesson[]
    assignmentId: string | null
  })[]
}

interface ContinueTarget {
  trackSlug: string
  moduleSlug: string
  lessonSlug: string
  lessonTitle: string
}

interface Program {
  bundleId: string
  bundleName: string
  phases: TrackTree[]
  currentPhaseIndex: number
  continueTarget: ContinueTarget | null
}

const levelLabel: Record<Track['level'], string> = {
  beginner: 'Beginner',
  intermediate: 'Intermediate',
  advanced: 'Advanced',
}

function findContinueTarget(track: TrackTree): ContinueTarget | null {
  for (const module of track.modules) {
    for (const lesson of module.lessons) {
      if (!lesson.completed) {
        return { trackSlug: track.slug, moduleSlug: module.slug, lessonSlug: lesson.slug, lessonTitle: lesson.title }
      }
    }
  }
  return null
}

export function Learn() {
  const { profile, bundleIds } = useAuth()
  const [programs, setPrograms] = useState<Program[]>([])
  const [soloTracks, setSoloTracks] = useState<TrackTree[]>([])
  const [otherTracks, setOtherTracks] = useState<TrackTree[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    async function load() {
      const {
        data: { user },
      } = await supabase.auth.getUser()

      const [
        { data: trackRows },
        { data: moduleRows },
        { data: bundleTrackRows },
        { data: bundleRows },
        { data: grantRows },
      ] = await Promise.all([
        supabase.from('tracks').select('*').order('order_index'),
        supabase.from('modules').select('*').order('order_index'),
        supabase.from('bundle_tracks').select('bundle_id, track_id'),
        supabase.from('bundles').select('*'),
        user
          ? supabase.from('student_track_grants').select('track_id').eq('student_id', user.id)
          : Promise.resolve({ data: [] as { track_id: string }[] }),
      ])

      const trackList = trackRows ?? []
      const moduleList: Module[] = moduleRows ?? []
      const bundleTracks = bundleTrackRows ?? []
      const bundles: Bundle[] = bundleRows ?? []
      const grantedTrackIds = new Set((grantRows ?? []).map((g) => g.track_id))

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

      const unlockBundleIdsFor = (trackId: string) =>
        bundleTracks.filter((bt) => bt.track_id === trackId).map((bt) => bt.bundle_id)

      const canAccessViaBundle = (trackId: string) => {
        if (profile?.approval_status !== 'approved') return false
        return unlockBundleIdsFor(trackId).some((id) => bundleIds.includes(id))
      }

      const buildTrackTree = (t: Track): TrackTree => {
        const modules = moduleList
          .filter((m) => m.track_id === t.id)
          .map((m) => ({
            ...m,
            lessons: (catalogLessons ?? [])
              .filter((l) => l.module_id === m.id)
              .map((l) => ({ ...l, completed: isLessonComplete(l.id) })),
            assignmentId: (moduleAssignments ?? []).find((a) => a.module_id === m.id)?.id ?? null,
          }))
        const allLessons = modules.flatMap((m) => m.lessons)
        return {
          ...t,
          unlockBundleName: bundles.find((b) => unlockBundleIdsFor(t.id).includes(b.id))?.name ?? null,
          complete: allLessons.length > 0 && allLessons.every((l) => l.completed),
          modules,
        }
      }

      const claimedTrackIds = new Set<string>()
      const builtPrograms: Program[] = []

      for (const bundleId of bundleIds) {
        const bundle = bundles.find((b) => b.id === bundleId)
        if (!bundle) continue
        const tracksForBundle = trackList
          .filter((t) => unlockBundleIdsFor(t.id).includes(bundleId))
          .filter((t) => !claimedTrackIds.has(t.id))
          .filter(() => profile?.approval_status === 'approved')
        if (tracksForBundle.length === 0) continue
        tracksForBundle.forEach((t) => claimedTrackIds.add(t.id))

        const phases = tracksForBundle.map(buildTrackTree)
        const currentPhaseIndex = Math.max(
          0,
          phases.findIndex((p) => !p.complete),
        )
        const activePhase = phases[currentPhaseIndex === -1 ? phases.length - 1 : currentPhaseIndex]
        builtPrograms.push({
          bundleId,
          bundleName: bundle.name,
          phases,
          currentPhaseIndex: currentPhaseIndex === -1 ? phases.length - 1 : currentPhaseIndex,
          continueTarget: activePhase ? findContinueTarget(activePhase) : null,
        })
      }

      const solo = trackList
        .filter((t) => grantedTrackIds.has(t.id) && !claimedTrackIds.has(t.id))
        .map((t) => {
          claimedTrackIds.add(t.id)
          return buildTrackTree(t)
        })

      const remaining = trackList
        .filter((t) => !claimedTrackIds.has(t.id))
        .map((t) => ({ tree: buildTrackTree(t), accessible: canAccessViaBundle(t.id) }))

      setPrograms(builtPrograms)
      setSoloTracks(solo)
      setOtherTracks(remaining.filter((r) => !r.accessible).map((r) => r.tree))
      setLoading(false)
    }
    load()
  }, [profile, bundleIds])

  if (loading) {
    return (
      <div className="flex justify-center py-20 text-accent">
        <SpinnerIcon className="animate-spin" size={24} />
      </div>
    )
  }

  const hasAnyAccess = programs.length > 0 || soloTracks.length > 0

  return (
    <div className="page-frame">
      <p className="page-kicker">Track catalog</p><h1 className="page-title">Learn</h1>
      <p className="page-intro">Pick up exactly where you left off.</p>

      <div className="mt-8 flex flex-col gap-6">
        {programs.map((program) => (
          <ProgramCard key={program.bundleId} program={program} />
        ))}

        {soloTracks.map((track) => (
          <SingleTrackCard key={track.id} track={track} />
        ))}

        {!hasAnyAccess && (
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

function ProgramCard({ program }: { program: Program }) {
  const [overrides, setOverrides] = useState<Record<string, boolean>>({})

  function toggle(trackId: string, defaultOpen: boolean) {
    setOverrides((prev) => ({ ...prev, [trackId]: !(prev[trackId] ?? defaultOpen) }))
  }

  return (
    <div className="rounded-2xl border border-accent/30 bg-surface/40 px-4 py-5 shadow-lg shadow-black/10 sm:px-6 sm:py-6">
      <p className="page-kicker">{program.bundleName} program</p>
      <h2 className="mt-1 font-heading text-2xl text-text">{program.bundleName}</h2>

      {program.continueTarget ? (
        <Link
          to={`/learn/${program.continueTarget.trackSlug}/${program.continueTarget.moduleSlug}/${program.continueTarget.lessonSlug}`}
          className="forge-button mt-4 w-full justify-center gap-1.5 px-4 py-3 sm:w-auto"
        >
          Continue: {program.continueTarget.lessonTitle}
          <ChevronRightIcon size={18} />
        </Link>
      ) : (
        <p className="mt-3 rounded-xl border border-success/30 bg-success/5 px-4 py-3 text-sm text-text">
          You've completed every phase in this program.
        </p>
      )}

      <div className="mt-6 flex flex-col gap-3 border-t border-border/70 pt-5">
        {program.phases.map((phase, i) => {
          const isCurrent = i === program.currentPhaseIndex
          const defaultOpen = isCurrent
          const open = overrides[phase.id] ?? defaultOpen
          return (
            <div key={phase.id} className="rounded-xl border border-border/70 bg-background/30">
              <button
                type="button"
                onClick={() => toggle(phase.id, defaultOpen)}
                className="flex w-full items-center justify-between gap-3 px-4 py-3 text-left"
              >
                <div className="flex min-w-0 items-center gap-3">
                  <span
                    className={`flex h-7 w-7 shrink-0 items-center justify-center rounded-full text-xs font-medium ${
                      phase.complete
                        ? 'bg-success/15 text-success'
                        : isCurrent
                          ? 'bg-accent/15 text-accent'
                          : 'bg-border/40 text-text-secondary'
                    }`}
                  >
                    {phase.complete ? <CheckCircleIcon size={16} /> : i + 1}
                  </span>
                  <div className="min-w-0">
                    <p className="truncate text-sm font-medium text-text">
                      Phase {i + 1}: {phase.name}
                    </p>
                    {!isCurrent && !phase.complete && (
                      <p className="truncate text-xs text-text-secondary">Come back to this after the current phase, or jump in early</p>
                    )}
                  </div>
                </div>
                <ChevronRightIcon
                  size={16}
                  className={`shrink-0 text-text-secondary transition-transform ${open ? 'rotate-90' : ''}`}
                />
              </button>

              {open && (
                <div className="flex flex-col gap-5 border-t border-border/70 px-4 pb-5 pt-4">
                  {phase.description && (
                    <p className="-mt-2 text-sm text-text-secondary">{phase.description}</p>
                  )}
                  {phase.modules.map((module) => (
                    <div key={module.id}>
                      <p className="mb-1.5 text-xs uppercase tracking-wide text-text-secondary/70">
                        {module.name}
                      </p>
                      <div className="grid gap-2 lg:grid-cols-2">
                        {module.lessons.map((lesson) => (
                          <Link
                            key={lesson.id}
                            to={`/learn/${phase.slug}/${module.slug}/${lesson.slug}`}
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
                  <Link
                    to={`/learn/discussion/${phase.id}`}
                    className="flex w-fit items-center gap-1.5 text-sm text-accent hover:underline"
                  >
                    <MessageIcon size={14} />
                    Questions about this phase
                  </Link>
                </div>
              )}
            </div>
          )
        })}
      </div>
    </div>
  )
}

function SingleTrackCard({ track }: { track: TrackTree }) {
  return (
    <div className="rounded-2xl border border-border bg-surface/40 px-4 py-5 shadow-lg shadow-black/10 sm:px-6 sm:py-6">
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
      {track.description && <p className="mt-1 text-sm text-text-secondary">{track.description}</p>}

      <div className="mt-5 flex flex-col gap-5 border-t border-border/70 pt-5">
        {track.modules.map((module) => (
          <div key={module.id}>
            <p className="mb-1.5 text-xs uppercase tracking-wide text-text-secondary/70">{module.name}</p>
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
  )
}
