// Ask AI — Gemini-backed Q&A, context-aware to the current lesson/section.
// Runs server-side so the Gemini key never reaches the client, and so the
// daily per-student cap can't be bypassed by calling the API directly.
//
// Chats persist (ai_chats/ai_messages) so a student can start a new chat or
// reopen a past one. Follow-up turns get real memory via Gemini's `contents`
// array (the standard multi-turn pattern — there's no free way to do this,
// resending prior turns is inherent to a stateless API), but the window is
// bounded (last HISTORY_WINDOW messages) rather than the whole chat, and the
// bulky lesson/section content is only sent once on the first turn — later
// turns rely on the model already having seen it, not repeating it.

import { createClient } from 'jsr:@supabase/supabase-js@2'

const DAILY_CAP = 20
const HISTORY_WINDOW = 10
const GEMINI_MODEL = 'gemini-3.1-flash-lite'

const SYSTEM_INSTRUCTION = `You are Forge's embedded coding tutor, answering beginner students inline in a lesson.

Formatting rules (hard requirements, not optional):
- Any code MUST be in a fenced markdown code block with a language tag, e.g. \`\`\`js. Never mix raw code into a sentence.
- Prefer short paragraphs, numbered steps, or bullet points over a wall of text.
- Be genuinely explanatory, not a terse one-liner — but stay focused, no filler.
- Match the student's level: assume they are a beginner unless the lesson context says otherwise.`

interface RequestBody {
  chatId?: string
  mode: 'explain_differently' | 'question' | 'code_error'
  userText: string
  lessonId?: string
  sectionId?: string
  lessonTitle?: string
  sectionTitle?: string
  sectionContent?: string
  code?: string
  errorMessage?: string
}

function buildPrompt(body: RequestBody, includeFullContext: boolean): string {
  const context = includeFullContext
    ? [
        body.lessonTitle && `Lesson: ${body.lessonTitle}`,
        body.sectionTitle && `Section: ${body.sectionTitle}`,
        body.sectionContent && `Section content:\n${body.sectionContent}`,
      ]
        .filter(Boolean)
        .join('\n\n')
    : [body.lessonTitle && `Lesson: ${body.lessonTitle}`, body.sectionTitle && `Section: ${body.sectionTitle}`]
        .filter(Boolean)
        .join(', ')

  if (body.mode === 'explain_differently') {
    return `${context}\n\nThe student found this section confusing. Explain the same idea again, but differently — a new angle, analogy, or simpler breakdown. Don't just repeat it.`
  }

  if (body.mode === 'code_error') {
    return `${context}\n\nThe student's code broke. Explain what went wrong in plain language (not the raw error), and how to fix it.\n\nTheir code:\n\`\`\`\n${body.code ?? ''}\n\`\`\`\n\nError:\n${body.errorMessage ?? ''}`
  }

  return `${context}\n\nStudent question: ${body.userText}`
}

Deno.serve(async (req) => {
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  }

  if (req.method === 'OPTIONS') {
    return new Response(null, { headers: corsHeaders })
  }

  try {
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) {
      return new Response(JSON.stringify({ error: 'Missing Authorization header' }), {
        status: 401,
        headers: corsHeaders,
      })
    }

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
    )

    const {
      data: { user },
      error: userErr,
    } = await supabase.auth.getUser(authHeader.replace('Bearer ', ''))
    if (userErr || !user) {
      return new Response(JSON.stringify({ error: 'Invalid session' }), {
        status: 401,
        headers: corsHeaders,
      })
    }

    const today = new Date().toISOString().slice(0, 10)
    const { data: usage } = await supabase
      .from('ai_usage')
      .select('count')
      .eq('user_id', user.id)
      .eq('usage_date', today)
      .maybeSingle()

    if ((usage?.count ?? 0) >= DAILY_CAP) {
      return new Response(
        JSON.stringify({
          error: `You've hit today's Ask AI limit (${DAILY_CAP}). It resets tomorrow.`,
        }),
        { status: 429, headers: corsHeaders },
      )
    }

    const body: RequestBody = await req.json()

    const geminiKey = Deno.env.get('GEMINI_API_KEY')
    if (!geminiKey) {
      return new Response(JSON.stringify({ error: 'Ask AI is not configured yet.' }), {
        status: 503,
        headers: corsHeaders,
      })
    }

    // Resolve (or create) the chat this message belongs to.
    let chatId = body.chatId
    let history: { role: string; content: string }[] = []

    if (chatId) {
      const { data: historyRows } = await supabase
        .from('ai_messages')
        .select('role, content')
        .eq('chat_id', chatId)
        .order('created_at', { ascending: false })
        .limit(HISTORY_WINDOW)
      history = (historyRows ?? []).reverse()
    } else {
      const { data: chat, error: chatErr } = await supabase
        .from('ai_chats')
        .insert({
          user_id: user.id,
          lesson_id: body.lessonId ?? null,
          section_id: body.sectionId ?? null,
        })
        .select('id')
        .single()
      if (chatErr || !chat) throw new Error(chatErr?.message ?? 'Failed to create chat')
      chatId = chat.id
    }

    const prompt = buildPrompt(body, history.length === 0)

    await supabase.from('ai_messages').insert({ chat_id: chatId, role: 'user', content: body.userText })

    const contents = [
      ...history.map((m) => ({
        role: m.role === 'user' ? 'user' : 'model',
        parts: [{ text: m.content }],
      })),
      { role: 'user', parts: [{ text: prompt }] },
    ]

    const geminiRes = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/${GEMINI_MODEL}:generateContent?key=${geminiKey}`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          system_instruction: { parts: [{ text: SYSTEM_INSTRUCTION }] },
          contents,
        }),
      },
    )

    if (!geminiRes.ok) {
      const errText = await geminiRes.text()
      console.error('Gemini error:', errText)
      return new Response(JSON.stringify({ error: 'Ask AI had trouble responding. Try again.' }), {
        status: 502,
        headers: corsHeaders,
      })
    }

    const geminiJson = await geminiRes.json()
    const answer: string =
      geminiJson.candidates?.[0]?.content?.parts?.map((p: { text?: string }) => p.text ?? '').join('') ??
      "Sorry, I couldn't come up with an answer for that."

    await supabase.from('ai_messages').insert({ chat_id: chatId, role: 'assistant', content: answer })

    const chatUpdate: Record<string, string> = { updated_at: new Date().toISOString() }
    if (history.length === 0) chatUpdate.title = body.userText.slice(0, 60)
    await supabase.from('ai_chats').update(chatUpdate).eq('id', chatId)

    await supabase
      .from('ai_usage')
      .upsert(
        { user_id: user.id, usage_date: today, count: (usage?.count ?? 0) + 1 },
        { onConflict: 'user_id,usage_date' },
      )

    return new Response(
      JSON.stringify({ chatId, answer, remaining: DAILY_CAP - (usage?.count ?? 0) - 1 }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
    )
  } catch (err) {
    console.error(err)
    return new Response(JSON.stringify({ error: 'Something went wrong.' }), {
      status: 500,
      headers: corsHeaders,
    })
  }
})
