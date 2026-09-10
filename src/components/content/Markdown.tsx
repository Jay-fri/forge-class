import ReactMarkdown from 'react-markdown'
import remarkGfm from 'remark-gfm'
import { PrismLight as SyntaxHighlighter } from 'react-syntax-highlighter'
import markup from 'react-syntax-highlighter/dist/esm/languages/prism/markup'
import css from 'react-syntax-highlighter/dist/esm/languages/prism/css'
import javascript from 'react-syntax-highlighter/dist/esm/languages/prism/javascript'
import jsx from 'react-syntax-highlighter/dist/esm/languages/prism/jsx'
import typescript from 'react-syntax-highlighter/dist/esm/languages/prism/typescript'
import json from 'react-syntax-highlighter/dist/esm/languages/prism/json'
import python from 'react-syntax-highlighter/dist/esm/languages/prism/python'
import php from 'react-syntax-highlighter/dist/esm/languages/prism/php'
import bash from 'react-syntax-highlighter/dist/esm/languages/prism/bash'
import { vscDarkPlus } from 'react-syntax-highlighter/dist/esm/styles/prism'

// Only the languages Forge's curriculum actually uses — the default
// react-syntax-highlighter import bundles every Prism grammar (~1MB+).
SyntaxHighlighter.registerLanguage('html', markup)
SyntaxHighlighter.registerLanguage('xml', markup)
SyntaxHighlighter.registerLanguage('css', css)
SyntaxHighlighter.registerLanguage('javascript', javascript)
SyntaxHighlighter.registerLanguage('js', javascript)
SyntaxHighlighter.registerLanguage('jsx', jsx)
SyntaxHighlighter.registerLanguage('typescript', typescript)
SyntaxHighlighter.registerLanguage('ts', typescript)
SyntaxHighlighter.registerLanguage('json', json)
SyntaxHighlighter.registerLanguage('python', python)
SyntaxHighlighter.registerLanguage('py', python)
SyntaxHighlighter.registerLanguage('php', php)
SyntaxHighlighter.registerLanguage('bash', bash)
SyntaxHighlighter.registerLanguage('sh', bash)

/**
 * Brand-styled markdown renderer — used for lesson/section content and (in
 * Phase 3) Ask AI responses. Tables, numbered steps, and code blocks are
 * first-class per the content standard, not an afterthought. Code blocks
 * get a macOS-style window chrome (matching the landing hero mockup) and
 * real VS Code (Dark+) syntax coloring, not flat monospace text.
 */
export function Markdown({ children }: { children: string }) {
  return (
    <div className="flex flex-col gap-4 text-base leading-relaxed text-text-secondary [&_strong]:text-text">
      <ReactMarkdown
        remarkPlugins={[remarkGfm]}
        components={{
          h1: ({ children }) => (
            <h1 className="mt-2 font-heading text-2xl text-text">{children}</h1>
          ),
          h2: ({ children }) => (
            <h2 className="mt-2 font-heading text-xl text-text">{children}</h2>
          ),
          h3: ({ children }) => (
            <h3 className="mt-2 font-heading text-lg text-text">{children}</h3>
          ),
          p: ({ children }) => <p>{children}</p>,
          ul: ({ children }) => (
            <ul className="list-disc space-y-1.5 pl-5">{children}</ul>
          ),
          ol: ({ children }) => (
            <ol className="list-decimal space-y-1.5 pl-5">{children}</ol>
          ),
          table: ({ children }) => (
            <div className="overflow-x-auto rounded-lg border border-border">
              <table className="w-full border-collapse text-sm">{children}</table>
            </div>
          ),
          thead: ({ children }) => (
            <thead className="bg-surface text-text">{children}</thead>
          ),
          th: ({ children }) => (
            <th className="border-b border-border px-3 py-2 text-left font-medium">
              {children}
            </th>
          ),
          td: ({ children }) => (
            <td className="border-b border-border px-3 py-2">{children}</td>
          ),
          // The outer <pre> is left to the code block below (via PreTag)
          // to avoid nesting two <pre> elements.
          pre: ({ children }) => <>{children}</>,
          code: ({ className, children }) => {
            const match = /language-(\w+)/.exec(className ?? '')
            if (!match) {
              return (
                <code className="rounded bg-surface px-1.5 py-0.5 font-mono text-[13px] text-accent">
                  {children}
                </code>
              )
            }
            const language = match[1]
            const code = String(children).replace(/\n$/, '')
            return (
              <div className="my-1 overflow-hidden rounded-lg border border-border">
                <div className="flex items-center gap-1.5 border-b border-border bg-background px-3 py-2">
                  <span className="h-2.5 w-2.5 rounded-full bg-border" />
                  <span className="h-2.5 w-2.5 rounded-full bg-border" />
                  <span className="h-2.5 w-2.5 rounded-full bg-border" />
                  <span className="ml-2 font-mono text-xs text-text-secondary">
                    {language}
                  </span>
                </div>
                <SyntaxHighlighter
                  language={language}
                  style={vscDarkPlus}
                  PreTag="div"
                  customStyle={{
                    margin: 0,
                    padding: '1rem',
                    fontSize: 13,
                    fontFamily: 'var(--font-mono)',
                  }}
                  codeTagProps={{ style: { fontFamily: 'var(--font-mono)' } }}
                >
                  {code}
                </SyntaxHighlighter>
              </div>
            )
          },
        }}
      >
        {children}
      </ReactMarkdown>
    </div>
  )
}
