import { supabase } from './supabase'

export interface AskAiContext {
  lessonId?: string
  sectionId?: string
  lessonTitle?: string
  sectionTitle?: string
  sectionContent?: string
}

export interface AskAiParams extends AskAiContext {
  chatId?: string
  mode: 'explain_differently' | 'question' | 'code_error'
  userText: string
  code?: string
  errorMessage?: string
}

export interface AskAiResult {
  chatId: string
  answer: string
  remaining: number
}

export async function askAi(params: AskAiParams): Promise<AskAiResult> {
  const { data, error } = await supabase.functions.invoke('ask-ai', { body: params })

  if (error) {
    // supabase-js surfaces non-2xx responses as an error with the original
    // Response on `.context` — pull our own {error: "..."} message out of it.
    const context = (error as { context?: Response }).context
    let serverMessage: string | undefined
    if (context) {
      try {
        const body = await context.json()
        serverMessage = body?.error
      } catch {
        // response wasn't JSON — fall through to the generic message below
      }
    }
    throw new Error(serverMessage ?? 'Ask AI is unavailable right now. Try again in a moment.')
  }

  return data as AskAiResult
}

export interface AiChatSummary {
  id: string
  title: string
  lesson_id: string | null
  section_id: string | null
  updated_at: string
}

export async function listAiChats(): Promise<AiChatSummary[]> {
  const { data } = await supabase
    .from('ai_chats')
    .select('id, title, lesson_id, section_id, updated_at')
    .order('updated_at', { ascending: false })
  return data ?? []
}

export interface AiChatMessage {
  id: string
  role: 'user' | 'assistant'
  content: string
  created_at: string
}

export async function loadAiChatMessages(chatId: string): Promise<AiChatMessage[]> {
  const { data } = await supabase
    .from('ai_messages')
    .select('id, role, content, created_at')
    .eq('chat_id', chatId)
    .order('created_at', { ascending: true })
  return data ?? []
}
