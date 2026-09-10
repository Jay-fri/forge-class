import { useState } from 'react'
import type { Database } from '../../lib/database.types'
import { CheckCircleIcon, RefreshIcon, XIcon } from '../icons'

type Quiz = Database['public']['Tables']['section_quizzes']['Row']

export function QuizCheck({ quiz }: { quiz: Quiz }) {
  const [selected, setSelected] = useState<number | null>(null)

  const answered = selected !== null
  const correct = selected === quiz.correct_index

  return (
    <div className="forge-card--accent forge-card p-4 sm:p-5">
      <p className="page-kicker">Quick check</p>
      <p className="mt-2 text-lg font-medium text-text">{quiz.question}</p>

      <div className="mt-3 flex flex-col gap-2">
        {quiz.options.map((option, i) => {
          const isSelected = selected === i
          const showCorrect = answered && i === quiz.correct_index
          const showWrong = answered && isSelected && !correct

          return (
            <button
              key={i}
              type="button"
              disabled={answered}
              onClick={() => setSelected(i)}
              className={`flex items-center justify-between rounded-lg border px-3.5 py-2.5 text-left text-sm transition-colors ${
                showCorrect
                  ? 'border-success/50 bg-success/10 text-success'
                  : showWrong
                    ? 'border-accent/40 bg-accent/10 text-accent'
                    : 'border-border bg-surface text-text hover:border-accent/60'
              } ${answered ? 'cursor-default' : ''}`}
            >
              {option}
              {showCorrect && <CheckCircleIcon size={16} />}
              {showWrong && <XIcon size={16} />}
            </button>
          )
        })}
      </div>

      {answered && (
        <div className="mt-3 flex items-start justify-between gap-3">
          {quiz.explanation && (
            <p className="text-sm text-text-secondary">{quiz.explanation}</p>
          )}
          {!correct && (
            <button
              type="button"
              onClick={() => setSelected(null)}
              className="flex shrink-0 items-center gap-1.5 text-sm text-accent hover:underline"
            >
              <RefreshIcon size={14} />
              Try again
            </button>
          )}
        </div>
      )}
    </div>
  )
}
