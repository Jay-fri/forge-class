import { supabase } from './supabase'

export interface SearchResult {
  key: string
  lessonTitle: string
  sectionTitle: string | null
  snippet: string
  trackName: string
  to: string
}

function stripMarkdown(text: string): string {
  return text
    .replace(/```[\s\S]*?```/g, ' ')
    .replace(/[#*_`>]/g, '')
    .replace(/\s+/g, ' ')
    .trim()
}

function snippetAround(content: string, query: string): string {
  const plain = stripMarkdown(content)
  const idx = plain.toLowerCase().indexOf(query.toLowerCase())
  if (idx === -1) return plain.slice(0, 140)
  const start = Math.max(0, idx - 50)
  const end = Math.min(plain.length, idx + query.length + 90)
  return `${start > 0 ? '…' : ''}${plain.slice(start, end)}${end < plain.length ? '…' : ''}`
}

interface TrackRef {
  slug: string
  name: string
}
interface ModuleRef {
  slug: string
  track_id: string
  tracks: TrackRef
}
interface LessonRef {
  title: string
  slug: string
  module_id: string
  modules: ModuleRef
}

export async function searchLessons(query: string): Promise<SearchResult[]> {
  const q = query.trim()
  if (q.length < 2) return []
  const like = `%${q}%`

  const [{ data: sectionMatches }, { data: lessonMatches }] = await Promise.all([
    supabase
      .from('sections')
      .select('id, title, content, lessons!inner(title, slug, module_id, modules!inner(slug, track_id, tracks!inner(slug, name)))')
      .or(`title.ilike.${like},content.ilike.${like}`)
      .limit(20),
    supabase
      .from('lessons')
      .select('id, title, slug, module_id, modules!inner(slug, track_id, tracks!inner(slug, name))')
      .ilike('title', like)
      .limit(10),
  ])

  const results: SearchResult[] = []

  for (const s of (sectionMatches ?? []) as unknown as {
    id: string
    title: string | null
    content: string | null
    lessons: LessonRef
  }[]) {
    const lesson = s.lessons
    const track = lesson.modules.tracks
    results.push({
      key: `section-${s.id}`,
      lessonTitle: lesson.title,
      sectionTitle: s.title,
      snippet: snippetAround(s.title && s.title.toLowerCase().includes(q.toLowerCase()) ? s.title : s.content ?? '', q),
      trackName: track.name,
      to: `/learn/${track.slug}/${lesson.modules.slug}/${lesson.slug}`,
    })
  }

  for (const l of (lessonMatches ?? []) as unknown as {
    id: string
    title: string
    slug: string
    modules: ModuleRef
  }[]) {
    const track = l.modules.tracks
    results.push({
      key: `lesson-${l.id}`,
      lessonTitle: l.title,
      sectionTitle: null,
      snippet: '',
      trackName: track.name,
      to: `/learn/${track.slug}/${l.modules.slug}/${l.slug}`,
    })
  }

  // A lesson title match and a section match can point at the same lesson —
  // keep the more specific (section-level) one when both exist.
  const seenLessonPaths = new Set(results.filter((r) => r.key.startsWith('section-')).map((r) => r.to))
  return results.filter((r) => r.key.startsWith('section-') || !seenLessonPaths.has(r.to))
}
