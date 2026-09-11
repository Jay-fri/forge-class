import type { Session, User } from '@supabase/supabase-js'
import {
  createContext,
  useContext,
  useEffect,
  useState,
  type ReactNode,
} from 'react'
import { supabase } from '../lib/supabase'
import type { Database } from '../lib/database.types'

type Profile = Database['public']['Tables']['profiles']['Row']

interface AuthContextValue {
  session: Session | null
  user: User | null
  profile: Profile | null
  bundleIds: string[]
  loading: boolean
  signInWithPassword: (email: string, password: string) => Promise<{ error: string | null }>
  signUpWithPassword: (
    email: string,
    password: string,
    fullName: string,
    bundleIds: string[],
  ) => Promise<{ error: string | null; needsEmailConfirmation: boolean }>
  signOut: () => Promise<void>
  refreshProfile: () => Promise<void>
}

const AuthContext = createContext<AuthContextValue | undefined>(undefined)

export function AuthProvider({ children }: { children: ReactNode }) {
  const [session, setSession] = useState<Session | null>(null)
  const [profile, setProfile] = useState<Profile | null>(null)
  const [bundleIds, setBundleIds] = useState<string[]>([])
  const [loading, setLoading] = useState(true)

  async function loadProfile(userId: string) {
    const [{ data }, { data: bundleRows }] = await Promise.all([
      supabase.from('profiles').select('*').eq('id', userId).single(),
      supabase.from('student_bundles').select('bundle_id').eq('student_id', userId),
    ])
    setProfile(data ?? null)
    setBundleIds((bundleRows ?? []).map((b) => b.bundle_id))
  }

  useEffect(() => {
    let active = true

    supabase.auth.getSession().then(async ({ data }) => {
      if (!active) return
      setSession(data.session)
      if (data.session) await loadProfile(data.session.user.id)
      setLoading(false)
    })

    const { data: listener } = supabase.auth.onAuthStateChange(
      async (_event, nextSession) => {
        // A sign-in/sign-up event means the session updates before the
        // matching profile row has been fetched — without this, routes
        // that gate on `profile` would briefly see session-but-no-profile
        // and bounce to /login while the fetch is still in flight.
        setLoading(true)
        setSession(nextSession)
        if (nextSession) {
          await loadProfile(nextSession.user.id)
        } else {
          setProfile(null)
          setBundleIds([])
        }
        setLoading(false)
      },
    )

    return () => {
      active = false
      listener.subscription.unsubscribe()
    }
  }, [])

  async function signInWithPassword(email: string, password: string) {
    const { error } = await supabase.auth.signInWithPassword({ email, password })
    return { error: error?.message ?? null }
  }

  async function signUpWithPassword(
    email: string,
    password: string,
    fullName: string,
    bundleIds: string[],
  ) {
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: { data: { full_name: fullName, bundle_ids: bundleIds } },
    })
    if (error) return { error: error.message, needsEmailConfirmation: false }
    // If email confirmation is required, signUp succeeds but returns no
    // session — there's nothing to redirect into yet.
    return { error: null, needsEmailConfirmation: !data.session }
  }

  async function signOut() {
    await supabase.auth.signOut()
  }

  async function refreshProfile() {
    if (session) await loadProfile(session.user.id)
  }

  return (
    <AuthContext.Provider
      value={{
        session,
        user: session?.user ?? null,
        profile,
        bundleIds,
        loading,
        signInWithPassword,
        signUpWithPassword,
        signOut,
        refreshProfile,
      }}
    >
      {children}
    </AuthContext.Provider>
  )
}

export function useAuth() {
  const ctx = useContext(AuthContext)
  if (!ctx) throw new Error('useAuth must be used within an AuthProvider')
  return ctx
}
