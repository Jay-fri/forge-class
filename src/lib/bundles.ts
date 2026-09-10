import { useEffect, useState } from 'react'
import { supabase } from './supabase'
import type { Database } from './database.types'

export type Bundle = Database['public']['Tables']['bundles']['Row']

export function useActiveBundles() {
  const [bundles, setBundles] = useState<Bundle[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    let active = true
    supabase
      .from('bundles')
      .select('*')
      .eq('is_active', true)
      .order('price', { ascending: true })
      .then(({ data }) => {
        if (!active) return
        setBundles(data ?? [])
        setLoading(false)
      })
    return () => {
      active = false
    }
  }, [])

  return { bundles, loading }
}

export function formatPrice(price: number, currency: string) {
  // Avoid the "₦" glyph — it's missing from our self-hosted font subset and
  // renders as a broken fallback glyph (looks like a strikethrough) on some
  // systems. The ISO code renders correctly everywhere.
  return `${currency} ${price.toLocaleString()}`
}
