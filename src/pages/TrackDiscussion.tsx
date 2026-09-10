import { useParams } from 'react-router-dom'
import { DiscussionPanel } from '../components/community/DiscussionPanel'

export function TrackDiscussion() {
  const { trackId } = useParams<{ trackId: string }>()
  return (
    <div className="page-frame flex h-[calc(100svh-8.5rem)] flex-col lg:h-[calc(100svh-1rem)]">
      <div className="forge-card flex min-h-0 flex-1 overflow-hidden"><DiscussionPanel trackId={trackId} /></div>
    </div>
  )
}
