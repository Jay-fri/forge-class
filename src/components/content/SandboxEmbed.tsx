import { Sandpack } from '@codesandbox/sandpack-react'
import { forgeSandpackTheme } from '../../lib/sandpackTheme'

const validTemplates = ['static', 'vanilla', 'react', 'vue', 'angular'] as const
type SandpackTemplate = (typeof validTemplates)[number]

export function SandboxEmbed({
  template,
  files,
}: {
  template: string
  files: Record<string, string>
}) {
  const safeTemplate: SandpackTemplate = (validTemplates as readonly string[]).includes(template)
    ? (template as SandpackTemplate)
    : 'vanilla'

  return (
    <div className="overflow-hidden rounded-2xl border border-border bg-surface shadow-lg shadow-black/10">
      {/* Sandpack's own layout is a fixed-width horizontal split (editor +
          preview) with no built-in responsive stacking. Rather than fight
          its internal CSS, this scrolls horizontally below the breakpoint
          where that split would otherwise clip the preview pane. */}
      <div className="overflow-x-auto">
        <div className="min-w-160">
          <Sandpack
            template={safeTemplate}
            files={files}
            theme={forgeSandpackTheme}
            options={{
              showLineNumbers: true,
              showInlineErrors: true,
              editorHeight: 320,
              editorWidthPercentage: 50,
            }}
          />
        </div>
      </div>
    </div>
  )
}
