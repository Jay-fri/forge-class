import { useState, type FormEvent } from 'react'
import {
  askAi,
  listAiChats,
  loadAiChatMessages,
  type AskAiContext,
  type AiChatSummary,
} from '../../lib/askAi'
import { Markdown } from '../content/Markdown'
import {
  ChevronLeftIcon,
  ClockIcon,
  ForgeMark,
  PlusIcon,
  SparkleIcon,
  SpinnerIcon,
  XIcon,
} from '../icons'

interface ChatMessage {
  role: 'user' | 'ai' | 'error'
  text: string
}

export function AskAiPanel({
  context,
  onClose,
}: {
  context?: AskAiContext
  onClose?: () => void
}) {
  const [view, setView] = useState<'chat' | 'history'>('chat')
  const [chatId, setChatId] = useState<string | null>(null)
  const [messages, setMessages] = useState<ChatMessage[]>([])
  const [input, setInput] = useState('')
  const [sending, setSending] = useState(false)
  const [chats, setChats] = useState<AiChatSummary[]>([])
  const [historyLoading, setHistoryLoading] = useState(false)

  async function send(userText: string, mode: 'question' | 'explain_differently') {
    if (sending) return
    setMessages((m) => [...m, { role: 'user', text: userText }])
    setInput('')
    setSending(true)
    try {
      const result = await askAi({
        chatId: chatId ?? undefined,
        mode,
        userText,
        ...context,
      })
      setChatId(result.chatId)
      setMessages((m) => [...m, { role: 'ai', text: result.answer }])
    } catch (err) {
      setMessages((m) => [
        ...m,
        { role: 'error', text: err instanceof Error ? err.message : 'Something went wrong.' },
      ])
    } finally {
      setSending(false)
    }
  }

  function handleSubmit(e: FormEvent) {
    e.preventDefault()
    if (!input.trim()) return
    send(input.trim(), 'question')
  }

  function startNewChat() {
    setChatId(null)
    setMessages([])
    setView('chat')
  }

  async function openHistory() {
    setView('history')
    setHistoryLoading(true)
    setChats(await listAiChats())
    setHistoryLoading(false)
  }

  async function openChat(chat: AiChatSummary) {
    setHistoryLoading(true)
    const rows = await loadAiChatMessages(chat.id)
    setMessages(rows.map((r) => ({ role: r.role === 'user' ? 'user' : 'ai', text: r.content })))
    setChatId(chat.id)
    setView('chat')
    setHistoryLoading(false)
  }

  return (
    <div className="flex h-full flex-col bg-background">
      <header className="flex items-center gap-2 border-b border-border bg-surface/70 px-4 py-3">
        {view === 'history' ? (
          <button
            type="button"
            onClick={() => setView('chat')}
            className="text-text-secondary hover:text-text"
            aria-label="Back to chat"
          >
            <ChevronLeftIcon size={20} />
          </button>
        ) : (
          <span className="forge-icon-tile h-9 w-9 rounded-lg"><SparkleIcon className="text-accent" size={18} /></span>
        )}
        <h2 className="truncate font-heading text-lg text-text">
          {view === 'history' ? 'Past chats' : 'Ask AI'}
        </h2>
        {view === 'chat' && context?.sectionTitle && (
          <span className="ml-1 truncate text-xs text-text-secondary">
            about "{context.sectionTitle}"
          </span>
        )}
        <div className="ml-auto flex items-center gap-3">
          {view === 'chat' && (
            <>
              <button
                type="button"
                onClick={openHistory}
                className="text-text-secondary hover:text-text"
                aria-label="Past chats"
                title="Past chats"
              >
                <ClockIcon size={19} />
              </button>
              <button
                type="button"
                onClick={startNewChat}
                className="text-text-secondary hover:text-text"
                aria-label="New chat"
                title="New chat"
              >
                <PlusIcon size={19} />
              </button>
            </>
          )}
          {onClose && (
            <button
              type="button"
              onClick={onClose}
              className="text-text-secondary hover:text-text"
              aria-label="Close"
            >
              <XIcon size={20} />
            </button>
          )}
        </div>
      </header>

      {view === 'history' ? (
        <div className="flex-1 overflow-y-auto px-4 py-4">
          {historyLoading ? (
            <div className="flex justify-center py-10 text-accent">
              <SpinnerIcon className="animate-spin" size={22} />
            </div>
          ) : chats.length === 0 ? (
            <p className="py-10 text-center text-sm text-text-secondary">
              No past chats yet. Start one and it'll show up here.
            </p>
          ) : (
            <div className="flex flex-col gap-2">
              {chats.map((c) => (
                <button
                  key={c.id}
                  onClick={() => openChat(c)}
                  className="forge-card px-4 py-3 text-left transition-colors hover:border-accent/60"
                >
                  <p className="truncate text-text">{c.title}</p>
                  <p className="mt-0.5 text-xs text-text-secondary">
                    {new Date(c.updated_at).toLocaleDateString()}
                  </p>
                </button>
              ))}
            </div>
          )}
        </div>
      ) : (
        <div className="flex-1 overflow-y-auto px-4 py-4">
          {messages.length === 0 && (
            <div className="flex flex-col items-center gap-3 py-10 text-center">
              <span className="forge-icon-tile h-12 w-12"><ForgeMark className="text-accent" size={26} /></span>
              <p className="page-kicker">Your coding copilot</p>
              <p className="max-w-xs text-sm text-text-secondary">
                Ask anything about this lesson, or get an error explained in plain language.
              </p>
              {context?.sectionContent && (
                <button
                  type="button"
                  onClick={() => send('Explain this differently', 'explain_differently')}
                  className="rounded-full border border-accent/40 px-3.5 py-2 text-sm text-accent hover:bg-accent/10"
                >
                  Explain this differently
                </button>
              )}
            </div>
          )}

          <div className="flex flex-col gap-3">
            {messages.map((m, i) =>
              m.role === 'user' ? (
                <div key={i} className="ml-auto max-w-[85%] rounded-2xl rounded-br-sm bg-accent px-3.5 py-2.5 text-sm text-background">
                  {m.text}
                </div>
              ) : m.role === 'error' ? (
                <div key={i} className="max-w-[85%] rounded-2xl rounded-bl-sm border border-accent/30 bg-accent/10 px-3.5 py-2 text-sm text-accent">
                  {m.text}
                </div>
              ) : (
                <div key={i} className="max-w-[90%] rounded-2xl rounded-bl-sm border border-border bg-surface px-3.5 py-3 shadow-sm shadow-black/20">
                  <Markdown>{m.text}</Markdown>
                </div>
              ),
            )}
            {sending && (
              <div className="flex items-center gap-2 text-text-secondary">
                <SpinnerIcon className="animate-spin" size={16} />
                <span className="text-sm">Thinking…</span>
              </div>
            )}
          </div>
        </div>
      )}

      {view === 'chat' && (
        <form onSubmit={handleSubmit} className="flex gap-2 border-t border-border bg-surface/60 p-3">
          <input
            value={input}
            onChange={(e) => setInput(e.target.value)}
            placeholder="Ask a question…"
            className="forge-input flex-1"
          />
          <button
            type="submit"
            disabled={sending || !input.trim()}
            className="forge-button min-h-0 px-4 disabled:opacity-40"
          >
            Send
          </button>
        </form>
      )}
    </div>
  )
}
