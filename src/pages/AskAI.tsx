import { AskAiPanel } from '../components/askai/AskAiPanel'

export function AskAI() {
  return (
    <div className="page-frame flex h-[calc(100svh-8.5rem)] flex-col lg:h-[calc(100svh-1rem)]">
      <div className="forge-card flex min-h-0 flex-1 overflow-hidden">
        <AskAiPanel />
      </div>
    </div>
  )
}
