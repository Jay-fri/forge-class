import { supabase } from './supabase'

export interface AskAiContext {
  lessonTitle?: string
  sectionTitle?: string
  sectionContent?: string
}

export interface AskAiParams extends AskAiContext {
  mode: 'explain_differently' | 'question' | 'code_error'
  question?: string
  code?: string
  errorMessage?: string
}

export async function askAi(params: AskAiParams): Promise<{ answer: string }> {
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

  return data as { answer: string }
}
