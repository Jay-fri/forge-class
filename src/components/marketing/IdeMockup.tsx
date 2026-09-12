/**
 * Decorative code-editor mockup for the landing hero. Hand-built — no
 * screenshot dependency — window chrome, file tabs, file tree, and
 * hand-colored "syntax highlighting" matching the brand palette.
 * Swap for Joshua's reference screenshot if/when provided.
 */
export function IdeMockup() {
  return (
    <div className="flex h-full w-full flex-col overflow-hidden rounded-2xl border border-border bg-surface shadow-2xl shadow-black/40">
      {/* window chrome */}
      <div className="flex shrink-0 items-center gap-2 border-b border-border bg-background px-4 py-3">
        <span className="h-2.5 w-2.5 rounded-full bg-border" />
        <span className="h-2.5 w-2.5 rounded-full bg-border" />
        <span className="h-2.5 w-2.5 rounded-full bg-border" />
        <span className="ml-3 text-xs text-text-secondary">forge / lesson-03.jsx</span>
      </div>

      <div className="flex flex-1 text-[13px]">
        {/* file tree */}
        <aside className="hidden w-40 shrink-0 border-r border-border bg-background/60 px-3 py-4 sm:block">
          <p className="mb-2 text-[11px] uppercase tracking-wide text-text-secondary/70">
            Files
          </p>
          <ul className="flex flex-col gap-1.5 text-text-secondary">
            <li className="text-text-secondary/70">/ src</li>
            <li className="pl-3 rounded bg-accent/10 px-2 py-1 text-accent">
              App.jsx
            </li>
            <li className="pl-3">index.css</li>
            <li className="pl-3">main.jsx</li>
          </ul>
        </aside>

        {/* editor */}
        <div className="flex flex-1 flex-col">
          <div className="flex shrink-0 border-b border-border bg-background/40 text-xs">
            <span className="border-r border-border bg-surface px-4 py-2 text-text">
              App.jsx
            </span>
            <span className="px-4 py-2 text-text-secondary">index.css</span>
          </div>

          <pre className="flex-1 overflow-auto px-4 py-6 font-mono leading-loose">
            <code>
              <span className="text-text-secondary">1</span>
              {'  '}
              <span className="text-accent">function</span>{' '}
              <span className="text-text">Streak</span>
              <span className="text-text-secondary">(&#123; </span>
              <span className="text-text">days</span>
              <span className="text-text-secondary"> &#125;) &#123;</span>
              {'\n'}
              <span className="text-text-secondary">2</span>
              {'    '}
              <span className="text-accent">return</span>{' '}
              <span className="text-text-secondary">(</span>
              {'\n'}
              <span className="text-text-secondary">3</span>
              {'      '}
              <span className="text-text-secondary">&lt;</span>
              <span className="text-success">div</span>{' '}
              <span className="text-text">className</span>
              <span className="text-text-secondary">=</span>
              <span className="text-accent">"streak"</span>
              <span className="text-text-secondary">&gt;</span>
              {'\n'}
              <span className="text-text-secondary">4</span>
              {'        '}
              <span className="text-text-secondary">&lt;</span>
              <span className="text-success">Flame</span>
              <span className="text-text-secondary"> /&gt;</span>{' '}
              <span className="text-text-secondary">&#123;</span>
              <span className="text-text">days</span>
              <span className="text-text-secondary">&#125; </span>
              <span className="text-accent">"day streak"</span>
              {'\n'}
              <span className="text-text-secondary">5</span>
              {'      '}
              <span className="text-text-secondary">&lt;/</span>
              <span className="text-success">div</span>
              <span className="text-text-secondary">&gt;</span>
              {'\n'}
              <span className="text-text-secondary">6</span>
              {'    '}
              <span className="text-text-secondary">)</span>
              {'\n'}
              <span className="text-text-secondary">7</span>
              <span className="text-text-secondary">&#125;</span>
            </code>
          </pre>
        </div>

        {/* live preview */}
        <aside className="hidden w-40 shrink-0 border-l border-border bg-background/60 px-3 py-4 md:block">
          <p className="mb-3 text-[11px] uppercase tracking-wide text-text-secondary/70">
            Preview
          </p>
          <div className="flex items-center gap-2 rounded-lg border border-border bg-surface px-2.5 py-2">
            <FlameIcon className="text-accent" size={15} />
            <span className="text-xs text-text">12 day streak</span>
          </div>
        </aside>
      </div>
    </div>
  )
}
import { FlameIcon } from '../icons'
