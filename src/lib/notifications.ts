import { supabase } from './supabase'
import type { Database } from './database.types'

export type Notification = Database['public']['Tables']['notifications']['Row']

export async function listNotifications(): Promise<Notification[]> {
  const { data } = await supabase
    .from('notifications')
    .select('*')
    .order('created_at', { ascending: false })
    .limit(30)
  return data ?? []
}

export async function markNotificationsRead(ids: string[]): Promise<void> {
  if (ids.length === 0) return
  await supabase.from('notifications').update({ read_at: new Date().toISOString() }).in('id', ids)
}

let subscriptionSeq = 0

export function subscribeToNotifications(userId: string, onInsert: (n: Notification) => void) {
  // The topic includes a per-call sequence number, not just the user id:
  // React's StrictMode dev double-invoke of this effect fires mount, then
  // cleanup, then mount again, and removeChannel's unsubscribe is async —
  // so the second mount can run before the first channel finishes
  // unsubscribing. Reusing the same topic then hands back that same,
  // already-subscribed channel object, and .on() throws on it. A unique
  // topic per call sidesteps the collision entirely.
  const channel = supabase
    .channel(`notifications:${userId}:${++subscriptionSeq}`)
    .on(
      'postgres_changes',
      { event: 'INSERT', schema: 'public', table: 'notifications', filter: `user_id=eq.${userId}` },
      (payload) => onInsert(payload.new as Notification),
    )
    .subscribe()
  return () => {
    supabase.removeChannel(channel)
  }
}

export function timeAgo(iso: string): string {
  const seconds = Math.floor((Date.now() - new Date(iso).getTime()) / 1000)
  if (seconds < 60) return 'just now'
  const minutes = Math.floor(seconds / 60)
  if (minutes < 60) return `${minutes}m ago`
  const hours = Math.floor(minutes / 60)
  if (hours < 24) return `${hours}h ago`
  const days = Math.floor(hours / 24)
  if (days < 7) return `${days}d ago`
  return new Date(iso).toLocaleDateString()
}
