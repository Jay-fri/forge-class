import type { SandpackTheme } from '@codesandbox/sandpack-react'

/** Sandpack theme matching the Forge brand palette and Markdown code blocks. */
export const forgeSandpackTheme: SandpackTheme = {
  colors: {
    surface1: '#171c19',
    surface2: '#1d2320',
    surface3: '#232a24',
    clickable: '#9ba79b',
    base: '#f1f0ea',
    disabled: '#4b554e',
    hover: '#f1f0ea',
    accent: '#d9a75c',
    error: '#f87171',
    errorSurface: '#3a1f1f',
  },
  syntax: {
    plain: '#f1f0ea',
    comment: { color: '#9ba79b', fontStyle: 'italic' },
    keyword: '#d9a75c',
    tag: '#8fae7a',
    punctuation: '#9ba79b',
    definition: '#e8c384',
    property: '#8fae7a',
    static: '#c586c0',
    string: '#ce9178',
  },
  font: {
    body: 'Pangolin, system-ui, sans-serif',
    mono: 'JetBrains Mono, ui-monospace, monospace',
    size: '13px',
    lineHeight: '1.5',
  },
}
