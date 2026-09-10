import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { searchLessons, type SearchResult } from '../lib/search'
import { BookIcon, SearchIcon, SpinnerIcon } from '../components/icons'

export function Search() {
  const [query, setQuery] = useState('')
  const [results, setResults] = useState<SearchResult[]>([])
  const [loading, setLoading] = useState(false)
  const [searched, setSearched] = useState(false)

  useEffect(() => {
    if (query.trim().length < 2) {
      setResults([])
      setSearched(false)
      return
    }
    setLoading(true)
    const timer = setTimeout(async () => {
      const found = await searchLessons(query)
      setResults(found)
      setSearched(true)
      setLoading(false)
    }, 300)
    return () => clearTimeout(timer)
  }, [query])

  return (
    <div className="px-5 py-6">
      <h1 className="font-heading text-2xl text-text">Search</h1>
      <p className="mt-1 text-text-secondary">Find anything across the lessons you have access to.</p>

      <div className="relative mt-5">
        <SearchIcon size={18} className="pointer-events-none absolute left-3.5 top-1/2 -translate-y-1/2 text-text-secondary" />
        <input
          autoFocus
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          placeholder="Search lessons, sections, topics…"
          className="w-full rounded-xl border border-border bg-surface py-3 pl-10 pr-4 text-text outline-none focus:border-accent"
        />
      </div>

      <div className="mt-5 flex flex-col gap-2">
        {loading && (
          <div className="flex justify-center py-10 text-accent">
            <SpinnerIcon className="animate-spin" size={22} />
          </div>
        )}

        {!loading &&
          results.map((r) => (
            <Link
              key={r.key}
              to={r.to}
              className="flex items-start gap-3 rounded-xl border border-border bg-surface px-4 py-3 transition-colors hover:border-accent/40"
            >
              <span className="mt-0.5 flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-accent/10 text-accent">
                <BookIcon size={16} />
              </span>
              <div className="min-w-0">
                <p className="text-xs text-text-secondary">
                  {r.trackName}
                  {r.sectionTitle ? ` · ${r.lessonTitle}` : ''}
                </p>
                <p className="truncate font-medium text-text">{r.sectionTitle ?? r.lessonTitle}</p>
                {r.snippet && (
                  <p className="mt-0.5 line-clamp-2 text-sm text-text-secondary">{r.snippet}</p>
                )}
              </div>
            </Link>
          ))}

        {!loading && searched && results.length === 0 && (
          <p className="py-10 text-center text-text-secondary">No matches. Try a different word.</p>
        )}
      </div>
    </div>
  )
}
