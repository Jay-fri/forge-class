import { lazy, Suspense, useEffect, useRef, useState } from 'react'
import { Link, Navigate, useParams } from 'react-router-dom'
import { AnimatePresence, motion } from 'framer-motion'
import { supabase } from '../lib/supabase'
import type { Database } from '../lib/database.types'
import { Markdown } from '../components/content/Markdown'
import { QuizCheck } from '../components/content/QuizCheck'
import { ContentFeedbackControl } from '../components/content/ContentFeedbackControl'
import { AskAiPanel } from '../components/askai/AskAiPanel'
import { DiscussionPanel } from '../components/community/DiscussionPanel'
import { Toast } from '../components/Toast'
import { BookmarkControl } from '../components/content/BookmarkControl'
import {
  AlertIcon,
  CheckCircleIcon,
  ChevronLeftIcon,
  ChevronRightIcon,
  CodeIcon,
  HandTapIcon,
  LightbulbIcon,
  MessageIcon,
  SparkleIcon,
  SpinnerIcon,
} from '../components/icons'

const sectionTypeMeta = {
  concept: { label: 'Concept', icon: LightbulbIcon },
  code_example: { label: 'Code example', icon: CodeIcon },
  try_it: { label: 'Try it', icon: HandTapIcon },
  common_mistake: { label: 'Common mistake', icon: AlertIcon },
  check_in: null,
} as const

function SectionTypeBadge({ type }: { type: Section['section_type'] }) {
  const meta = sectionTypeMeta[type]
  if (!meta) return null
  const Icon = meta.icon
  return (
    <p className="flex items-center gap-1.5 page-kicker">
      <Icon size={14} />
      {meta.label}
    </p>
  )
}

type Lesson = Database['public']['Tables']['lessons']['Row']
type Section = Database['public']['Tables']['sections']['Row']
type Quiz = Database['public']['Tables']['section_quizzes']['Row']

// Sandpack pulls in a large bundler runtime — code-split so pages that
// never show a sandbox (most of them) don't pay for it.
const SandboxEmbed = lazy(() =>
  import('../components/content/SandboxEmbed').then((m) => ({ default: m.SandboxEmbed })),
)

export function LessonViewer() {
  const params = useParams<{ trackSlug: string; moduleSlug: string; lessonSlug: string }>()
  const trackSlug = params.trackSlug!
  const moduleSlug = params.moduleSlug!
  const lessonSlug = params.lessonSlug!

  const [lesson, setLesson] = useState<Lesson | null>(null)
  const [sections, setSections] = useState<Section[]>([])
  const [quizzesBySection, setQuizzesBySection] = useState<Map<string, Quiz[]>>(new Map())
  const [assignmentId, setAssignmentId] = useState<string | null>(null)
  const [notFound, setNotFound] = useState(false)
  const [loading, setLoading] = useState(true)

  const [currentIndex, setCurrentIndex] = useState(0)
  const [completed, setCompleted] = useState<Set<string>>(new Set())
  const [showCompletion, setShowCompletion] = useState(false)
  const [nextLessonPath, setNextLessonPath] = useState<string | null>(null)
  const [askAiOpen, setAskAiOpen] = useState(false)
  const [discussionOpen, setDiscussionOpen] = useState(false)
  const [badgeToast, setBadgeToast] = useState<string | null>(null)

  const touchStartX = useRef<number | null>(null)
  const mainRef = useRef<HTMLElement>(null)

  useEffect(() => {
    if (!badgeToast) return
    const timer = setTimeout(() => setBadgeToast(null), 4000)
    return () => clearTimeout(timer)
  }, [badgeToast])

  useEffect(() => {
    // Reset per-lesson state synchronously (before the async fetch below)
    // so a stale showCompletion=true from the previous lesson can never
    // flash for the newly-loaded one when navigating via "Next lesson".
    setLoading(true)
    setShowCompletion(false)
    setCurrentIndex(0)
    setCompleted(new Set())

    async function load() {
      const { data: trackRow } = await supabase
        .from('tracks')
        .select('id')
        .eq('slug', trackSlug)
        .maybeSingle()
      if (!trackRow) {
        setNotFound(true)
        setLoading(false)
        return
      }
      const { data: moduleRow } = await supabase
        .from('modules')
        .select('id')
        .eq('track_id', trackRow.id)
        .eq('slug', moduleSlug)
        .maybeSingle()
      if (!moduleRow) {
        setNotFound(true)
        setLoading(false)
        return
      }
      const { data: lessonRow } = await supabase
        .from('lessons')
        .select('*')
        .eq('module_id', moduleRow.id)
        .eq('slug', lessonSlug)
        .maybeSingle()
      if (!lessonRow) {
        setNotFound(true)
        setLoading(false)
        return
      }
      setLesson(lessonRow)

      const { data: lessonAssignment } = await supabase
        .from('assignments')
        .select('id')
        .eq('lesson_id', lessonRow.id)
        .maybeSingle()
      let resolvedAssignmentId = lessonAssignment?.id ?? null

      // Figure out where "next" goes: the next lesson in this module, or
      // the first lesson of the next module, so finishing a lesson can go
      // straight there instead of dropping back to the track catalog.
      const { data: siblingLessons } = await supabase
        .from('lessons')
        .select('slug, order_index')
        .eq('module_id', moduleRow.id)
        .order('order_index')
      const siblings = siblingLessons ?? []
      const myIndex = siblings.findIndex((l) => l.slug === lessonSlug)
      const isLastInModule = myIndex === -1 || myIndex === siblings.length - 1

      let nextPath: string | null = null
      if (!isLastInModule) {
        nextPath = `/learn/${trackSlug}/${moduleSlug}/${siblings[myIndex + 1].slug}`
      } else {
        const { data: moduleRows } = await supabase
          .from('modules')
          .select('id, slug, order_index')
          .eq('track_id', trackRow.id)
          .order('order_index')
        const modules = moduleRows ?? []
        const modIndex = modules.findIndex((m) => m.slug === moduleSlug)
        if (modIndex !== -1 && modIndex < modules.length - 1) {
          const nextModule = modules[modIndex + 1]
          const { data: nextModuleLessons } = await supabase
            .from('lessons')
            .select('slug')
            .eq('module_id', nextModule.id)
            .order('order_index')
            .limit(1)
          if (nextModuleLessons && nextModuleLessons.length > 0) {
            nextPath = `/learn/${trackSlug}/${nextModule.slug}/${nextModuleLessons[0].slug}`
          }
        }

        // Assignments usually cap off a module rather than a single lesson,
        // so only check module-level once we know this is the last lesson.
        if (!resolvedAssignmentId) {
          const { data: moduleAssignment } = await supabase
            .from('assignments')
            .select('id')
            .eq('module_id', moduleRow.id)
            .maybeSingle()
          resolvedAssignmentId = moduleAssignment?.id ?? null
        }
      }
      setNextLessonPath(nextPath)
      setAssignmentId(resolvedAssignmentId)

      const { data: sectionRows } = await supabase
        .from('sections')
        .select('*')
        .eq('lesson_id', lessonRow.id)
        .order('order_index')
      const sectionList = sectionRows ?? []
      setSections(sectionList)

      const sectionIds = sectionList.map((s) => s.id)
      if (sectionIds.length) {
        const { data: quizRows } = await supabase
          .from('section_quizzes')
          .select('*')
          .in('section_id', sectionIds)
          .order('order_index')
        const map = new Map<string, Quiz[]>()
        for (const q of quizRows ?? []) {
          map.set(q.section_id, [...(map.get(q.section_id) ?? []), q])
        }
        setQuizzesBySection(map)

        const {
          data: { user },
        } = await supabase.auth.getUser()
        if (user) {
          const { data: progressRows } = await supabase
            .from('user_progress')
            .select('section_id')
            .eq('user_id', user.id)
            .eq('status', 'completed')
            .in('section_id', sectionIds)
          const completedIds = new Set((progressRows ?? []).map((p) => p.section_id))
          setCompleted(completedIds)
          const firstIncomplete = sectionList.findIndex((s) => !completedIds.has(s.id))
          setCurrentIndex(firstIncomplete === -1 ? 0 : firstIncomplete)
        }
      }

      setLoading(false)
    }
    load()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [trackSlug, moduleSlug, lessonSlug])

  // Jump the scrollable reading pane back to the top whenever the section
  // or lesson changes, otherwise the next section renders below the fold
  // at whatever scroll position the previous (often longer) one left off.
  useEffect(() => {
    mainRef.current?.scrollTo({ top: 0 })
  }, [currentIndex, lessonSlug])

  async function markCompleted(section: Section) {
    const {
      data: { user },
    } = await supabase.auth.getUser()
    if (!user) return

    const { count: beforeCount } = await supabase
      .from('user_badges')
      .select('id', { count: 'exact', head: true })

    await supabase.rpc('complete_section', { p_section_id: section.id })
    setCompleted((prev) => new Set(prev).add(section.id))

    const { count: afterCount } = await supabase
      .from('user_badges')
      .select('id', { count: 'exact', head: true })

    if ((afterCount ?? 0) > (beforeCount ?? 0)) {
      const { data: newest } = await supabase
        .from('user_badges')
        .select('badges(name)')
        .order('earned_at', { ascending: false })
        .limit(1)
        .maybeSingle()
      const badgeName = (newest as unknown as { badges: { name: string } } | null)?.badges?.name
      if (badgeName) setBadgeToast(badgeName)
    }
  }

  async function goNext() {
    const section = sections[currentIndex]
    if (!section) return
    await markCompleted(section)
    if (currentIndex === sections.length - 1) {
      setShowCompletion(true)
    } else {
      setCurrentIndex((i) => i + 1)
    }
  }

  function goPrev() {
    setCurrentIndex((i) => Math.max(0, i - 1))
  }

  function onTouchStart(e: React.TouchEvent) {
    touchStartX.current = e.touches[0].clientX
  }
  function onTouchEnd(e: React.TouchEvent) {
    if (touchStartX.current === null) return
    const delta = e.changedTouches[0].clientX - touchStartX.current
    touchStartX.current = null
    if (Math.abs(delta) < 60) return
    if (delta < 0 && currentIndex < sections.length - 1) goNext()
    else if (delta > 0 && currentIndex > 0) goPrev()
  }

  if (notFound) return <Navigate to="/learn" replace />

  if (loading || !lesson) {
    return (
      <div className="flex min-h-svh items-center justify-center bg-background text-accent">
        <SpinnerIcon className="animate-spin" size={28} />
      </div>
    )
  }

  if (showCompletion) {
    return (
      <div className="student-view flex min-h-svh flex-col items-center justify-center gap-4 bg-background px-6 text-center">
        <motion.div
          initial={{ scale: 0.8, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          transition={{ type: 'spring', duration: 0.5, bounce: 0.35 }}
          className="flex h-16 w-16 items-center justify-center rounded-full bg-success/15 text-success"
        >
          <CheckCircleIcon size={32} />
        </motion.div>
        <h1 className="font-heading text-2xl text-text">Lesson complete</h1>
        <p className="text-text-secondary">Nice work, {lesson.title} is done.</p>

        <div className="mt-2 flex flex-col items-center gap-3">
          {nextLessonPath ? (
            <Link to={nextLessonPath} className="forge-button gap-1.5 px-5">
              Next lesson
              <ChevronRightIcon size={18} />
            </Link>
          ) : assignmentId ? (
            <Link to={`/learn/assignment/${assignmentId}`} className="forge-button px-5">
              View assignment
            </Link>
          ) : (
            <Link to="/learn" className="forge-button px-5">
              Back to Learn
            </Link>
          )}

          {nextLessonPath && assignmentId && (
            <Link
              to={`/learn/assignment/${assignmentId}`}
              className="text-sm text-text-secondary hover:text-text hover:underline"
            >
              View assignment
            </Link>
          )}

          {(nextLessonPath || assignmentId) && (
            <Link to="/learn" className="text-sm text-text-secondary hover:text-text hover:underline">
              Back to Learn
            </Link>
          )}
        </div>
      </div>
    )
  }

  const section = sections[currentIndex]

  return (
    <div className="student-view flex min-h-svh flex-col bg-background">
      <Toast message={badgeToast} />

      <header className="border-b border-border bg-background/95 px-4 py-3 backdrop-blur">
        <div className="mx-auto flex max-w-4xl items-center gap-3">
          <Link to="/learn" className="forge-icon-tile h-9 w-9 rounded-lg text-text-secondary hover:text-text">
            <ChevronLeftIcon size={22} />
          </Link>
          <div className="min-w-0"><p className="forge-panel-label">Lesson {currentIndex + 1} of {sections.length}</p><h1 className="truncate font-heading text-xl text-text">{lesson.title}</h1></div>
        </div>
      </header>

      <div className="px-4 pt-3">
        <div className="mx-auto flex max-w-4xl gap-1.5">
          {sections.map((s, i) => (
            <span
              key={s.id}
              className={`h-1.5 flex-1 rounded-full transition-colors ${
                i < currentIndex || completed.has(s.id)
                  ? 'bg-success'
                  : i === currentIndex
                    ? 'bg-accent'
                    : 'bg-border'
              }`}
            />
          ))}
        </div>
      </div>

      <main
        ref={mainRef}
        className="flex-1 overflow-y-auto px-4 py-6 pb-28 sm:px-6 lg:px-10"
        onTouchStart={onTouchStart}
        onTouchEnd={onTouchEnd}
      >
        {section && (
          <motion.div
            key={section.id}
            initial={{ opacity: 0, x: 16 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.25 }}
            className="forge-card mx-auto flex max-w-4xl flex-col gap-5 p-5 sm:p-8 lg:p-10"
          >
            {section.title ? (
              <div><p className="page-kicker">Section {currentIndex + 1}</p><h2 className="mt-1 font-heading text-3xl text-text">{section.title}</h2></div>
            ) : (
              <SectionTypeBadge type={section.section_type} />
            )}

            {section.content && section.section_type === 'common_mistake' ? (
              <div className="rounded-xl border border-accent/30 bg-accent/5 p-4">
                <Markdown>{section.content}</Markdown>
              </div>
            ) : section.content && section.section_type === 'try_it' ? (
              <div className="rounded-xl border border-success/30 bg-success/5 p-4">
                <Markdown>{section.content}</Markdown>
              </div>
            ) : (
              section.content && <Markdown>{section.content}</Markdown>
            )}

            {section.sandbox_files && (
              <Suspense
                fallback={
                  <div className="flex h-80 items-center justify-center rounded-lg border border-border bg-surface text-accent">
                    <SpinnerIcon className="animate-spin" size={22} />
                  </div>
                }
              >
                <SandboxEmbed
                  template={section.sandbox_template ?? 'vanilla'}
                  files={section.sandbox_files}
                />
              </Suspense>
            )}

            {(quizzesBySection.get(section.id) ?? []).map((quiz) => (
              <QuizCheck key={quiz.id} quiz={quiz} />
            ))}

            <BookmarkControl sectionId={section.id} />
            <ContentFeedbackControl sectionId={section.id} />
          </motion.div>
        )}
      </main>

      {/* Full-viewport, click-through overlay so the floating button can align
          to the reading column's edge on wide screens instead of the raw
          viewport edge, while staying pinned during scroll like a real FAB. */}
      <div className="pointer-events-none fixed inset-0 z-10">
        <div className="relative mx-auto h-full max-w-4xl">
          <button
            type="button"
            onClick={() => setDiscussionOpen(true)}
            aria-label="Questions"
            className="pointer-events-auto absolute bottom-40 right-4 flex h-12 w-12 items-center justify-center rounded-full border border-border bg-surface text-text shadow-lg hover:border-accent/60"
          >
            <MessageIcon size={20} />
          </button>
          <button
            type="button"
            onClick={() => setAskAiOpen(true)}
            aria-label="Ask AI"
            className="pointer-events-auto absolute bottom-24 right-4 flex h-12 items-center gap-2 rounded-full bg-accent px-4 text-background shadow-lg hover:opacity-90"
          >
            <SparkleIcon size={20} />
            <span className="text-sm font-medium">Ask AI</span>
          </button>
        </div>
      </div>

      <div className="fixed inset-x-0 bottom-0 border-t border-border bg-background px-4 py-3 pb-[calc(env(safe-area-inset-bottom)+0.75rem)]">
        <div className="mx-auto flex max-w-4xl gap-2">
          {currentIndex > 0 && (
            <button
              type="button"
              onClick={goPrev}
              aria-label="Previous section"
              className="flex items-center justify-center rounded-lg border border-border px-4 text-text-secondary hover:bg-surface"
            >
              <ChevronLeftIcon size={20} />
            </button>
          )}
          <button
            type="button"
            onClick={goNext}
            className="forge-button flex-1 gap-1.5 px-4 py-3"
          >
            {currentIndex === sections.length - 1 ? 'Finish lesson' : 'Continue'}
            <ChevronRightIcon size={18} />
          </button>
        </div>
      </div>

      <AnimatePresence>
        {askAiOpen && (
          <>
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              onClick={() => setAskAiOpen(false)}
              className="fixed inset-0 z-20 bg-black/60"
            />
            <motion.div
              initial={{ y: '100%' }}
              animate={{ y: 0 }}
              exit={{ y: '100%' }}
              transition={{ type: 'spring', damping: 30, stiffness: 300 }}
              className="fixed inset-x-0 bottom-0 z-30 h-[75svh] overflow-hidden rounded-t-2xl border-t border-border md:inset-x-auto md:bottom-6 md:right-6 md:h-[70svh] md:w-105 md:rounded-2xl md:border"
            >
              <AskAiPanel
                context={{
                  lessonId: lesson.id,
                  sectionId: section?.id ?? undefined,
                  lessonTitle: lesson.title,
                  sectionTitle: section?.title ?? undefined,
                  sectionContent: section?.content ?? undefined,
                }}
                onClose={() => setAskAiOpen(false)}
              />
            </motion.div>
          </>
        )}
      </AnimatePresence>

      <AnimatePresence>
        {discussionOpen && (
          <>
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              onClick={() => setDiscussionOpen(false)}
              className="fixed inset-0 z-20 bg-black/60"
            />
            <motion.div
              initial={{ y: '100%' }}
              animate={{ y: 0 }}
              exit={{ y: '100%' }}
              transition={{ type: 'spring', damping: 30, stiffness: 300 }}
              className="fixed inset-x-0 bottom-0 z-30 h-[75svh] overflow-hidden rounded-t-2xl border-t border-border md:inset-x-auto md:bottom-6 md:right-6 md:h-[70svh] md:w-105 md:rounded-2xl md:border"
            >
              <DiscussionPanel lessonId={lesson.id} onClose={() => setDiscussionOpen(false)} />
            </motion.div>
          </>
        )}
      </AnimatePresence>
    </div>
  )
}
