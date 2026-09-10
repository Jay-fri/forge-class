import { useParams } from 'react-router-dom'
import { DiscussionPanel } from '../components/community/DiscussionPanel'

export function TrackDiscussion() {
  const { trackId } = useParams<{ trackId: string }>()
  return (
    <div className="h-[calc(100svh-8.5rem)] lg:h-[calc(100svh-1rem)]">
      <DiscussionPanel trackId={trackId} />
    </div>
  )
}
