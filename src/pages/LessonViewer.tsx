import { lazy, Suspense, useEffect, useRef, useState } from 'react'
import { Link, Navigate, useParams } from 'react-router-dom'
import { AnimatePresence, motion } from 'framer-motion'
import { supabase } from '../lib/supabase'
import type { Database } from '../lib/database.types'
import { Markdown } from '../components/content/Markdown'
import { QuizCheck } from '../components/content/QuizCheck'
import { ContentFeedbackControl } from '../components/content/ContentFeedbackControl'
import { AskAiPanel } from '../components/askai/AskAiPanel'
import {
  CheckCircleIcon,
  ChevronLeftIcon,
  ChevronRightIcon,
  SparkleIcon,
  SpinnerIcon,
} from '../components/icons'

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
  const [notFound, setNotFound] = useState(false)
  const [loading, setLoading] = useState(true)

  const [currentIndex, setCurrentIndex] = useState(0)
  const [completed, setCompleted] = useState<Set<string>>(new Set())
  const [showCompletion, setShowCompletion] = useState(false)
  const [askAiOpen, setAskAiOpen] = useState(false)

  const touchStartX = useRef<number | null>(null)

  useEffect(() => {
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

  async function markCompleted(section: Section) {
    const {
      data: { user },
    } = await supabase.auth.getUser()
    if (!user) return
    await supabase
      .from('user_progress')
      .upsert(
        {
          user_id: user.id,
          section_id: section.id,
          status: 'completed',
          completed_at: new Date().toISOString(),
        },
        { onConflict: 'user_id,section_id' },
      )
    setCompleted((prev) => new Set(prev).add(section.id))
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
      <div className="flex min-h-svh flex-col items-center justify-center gap-4 bg-background px-6 text-center">
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
        <Link
          to="/learn"
          className="mt-2 rounded-lg bg-accent px-5 py-2.5 font-medium text-background hover:opacity-90"
        >
          Back to Learn
        </Link>
      </div>
    )
  }

  const section = sections[currentIndex]

  return (
    <div className="flex min-h-svh flex-col bg-background">
      <header className="border-b border-border px-4 py-3">
        <div className="mx-auto flex max-w-2xl items-center gap-3">
          <Link to="/learn" className="text-text-secondary hover:text-text">
            <ChevronLeftIcon size={22} />
          </Link>
          <h1 className="truncate font-heading text-lg text-text">{lesson.title}</h1>
        </div>
      </header>

      <div className="px-4 pt-3">
        <div className="mx-auto flex max-w-2xl gap-1.5">
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
        className="flex-1 overflow-y-auto px-5 py-6 pb-28"
        onTouchStart={onTouchStart}
        onTouchEnd={onTouchEnd}
      >
        {section && (
          <motion.div
            key={section.id}
            initial={{ opacity: 0, x: 16 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.25 }}
            className="mx-auto flex max-w-2xl flex-col gap-5"
          >
            {section.title && (
              <h2 className="font-heading text-xl text-text">{section.title}</h2>
            )}
            {section.content && <Markdown>{section.content}</Markdown>}

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

            <ContentFeedbackControl sectionId={section.id} />
          </motion.div>
        )}
      </main>

      {/* Full-viewport, click-through overlay so the floating button can align
          to the reading column's edge on wide screens instead of the raw
          viewport edge, while staying pinned during scroll like a real FAB. */}
      <div className="pointer-events-none fixed inset-0 z-10">
        <div className="relative mx-auto h-full max-w-2xl">
          <button
            type="button"
            onClick={() => setAskAiOpen(true)}
            aria-label="Ask AI"
            className="pointer-events-auto absolute bottom-24 right-4 flex h-12 w-12 items-center justify-center rounded-full bg-accent text-background shadow-lg hover:opacity-90"
          >
            <SparkleIcon size={22} />
          </button>
        </div>
      </div>

      <div className="fixed inset-x-0 bottom-0 border-t border-border bg-background px-4 py-3 pb-[calc(env(safe-area-inset-bottom)+0.75rem)]">
        <div className="mx-auto flex max-w-2xl gap-2">
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
            className="flex flex-1 items-center justify-center gap-1.5 rounded-lg bg-accent px-4 py-3 font-medium text-background hover:opacity-90"
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
    </div>
  )
}
