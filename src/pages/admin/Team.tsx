import { useEffect, useState } from 'react'
import { useAuth } from '../../contexts/AuthContext'
import { supabase } from '../../lib/supabase'
import type { Database, InstructorRole } from '../../lib/database.types'
import { SpinnerIcon } from '../../components/icons'

type Profile = Database['public']['Tables']['profiles']['Row']

export function Team() {
  const { profile: me } = useAuth()
  const isOwner = me?.instructor_role === 'owner'

  const [team, setTeam] = useState<Profile[]>([])
  const [loading, setLoading] = useState(true)
  const [searchEmail, setSearchEmail] = useState('')
  const [searchResult, setSearchResult] = useState<Profile | null>(null)
  const [searchError, setSearchError] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)

  async function load() {
    setLoading(true)
    const { data } = await supabase
      .from('profiles')
      .select('*')
      .eq('role', 'instructor')
      .order('created_at')
    setTeam(data ?? [])
    setLoading(false)
  }

  useEffect(() => {
    load()
  }, [])

  async function findStudent() {
    setSearchError(null)
    setSearchResult(null)
    const { data } = await supabase
      .from('profiles')
      .select('*')
      .eq('email', searchEmail.trim().toLowerCase())
      .maybeSingle()
    if (!data) {
      setSearchError('No account found with that email.')
      return
    }
    if (data.role === 'instructor') {
      setSearchError('Already a team member.')
      return
    }
    setSearchResult(data)
  }

  async function promote(student: Profile) {
    setBusy(true)
    await supabase
      .from('profiles')
      .update({ role: 'instructor', instructor_role: 'grader' })
      .eq('id', student.id)
    setBusy(false)
    setSearchResult(null)
    setSearchEmail('')
    await load()
  }

  async function changeRole(member: Profile, role: InstructorRole) {
    await supabase.from('profiles').update({ instructor_role: role }).eq('id', member.id)
    await load()
  }

  if (loading) {
    return (
      <div className="flex justify-center py-20 text-accent">
        <SpinnerIcon className="animate-spin" size={24} />
      </div>
    )
  }

  return (
    <div className="px-6 py-8">
      <h1 className="font-heading text-2xl text-text">Team</h1>
      <p className="mt-1 text-text-secondary">
        Owners manage everything. Graders can grade submissions and reply to content feedback.
      </p>

      <div className="mt-6 flex flex-col gap-2">
        {team.map((member) => (
          <div
            key={member.id}
            className="flex items-center justify-between rounded-xl border border-border bg-surface px-4 py-3"
          >
            <div>
              <p className="text-text">{member.full_name}</p>
              <p className="text-sm text-text-secondary">{member.email}</p>
            </div>
            {isOwner && member.id !== me?.id ? (
              <select
                value={member.instructor_role ?? 'grader'}
                onChange={(e) => changeRole(member, e.target.value as InstructorRole)}
                className="rounded-lg border border-border bg-background px-2.5 py-1.5 text-sm capitalize text-text"
              >
                <option value="owner">Owner</option>
                <option value="grader">Grader</option>
              </select>
            ) : (
              <span className="rounded-full border border-border px-2.5 py-1 text-xs capitalize text-text-secondary">
                {member.instructor_role ?? 'grader'}
                {member.id === me?.id ? ' · you' : ''}
              </span>
            )}
          </div>
        ))}
      </div>

      {isOwner ? (
        <>
          <h2 className="mt-8 font-heading text-lg text-text">Add a team member</h2>
          <p className="mt-1 text-sm text-text-secondary">
            They need an existing student account first, then promote it to grader here.
          </p>
          <div className="mt-3 flex flex-col gap-3 rounded-xl border border-border bg-surface p-4">
            <div className="flex gap-2">
              <input
                value={searchEmail}
                onChange={(e) => setSearchEmail(e.target.value)}
                placeholder="student@email.com"
                className="flex-1 rounded-lg border border-border bg-background px-3 py-2 text-text"
              />
              <button
                onClick={findStudent}
                className="rounded-lg border border-border px-4 py-2 text-sm text-text-secondary hover:bg-background"
              >
                Find
              </button>
            </div>
            {searchError && <p className="text-sm text-red-400">{searchError}</p>}
            {searchResult && (
              <div className="flex items-center justify-between rounded-lg border border-accent/30 bg-accent/5 px-3 py-2">
                <div>
                  <p className="text-text">{searchResult.full_name}</p>
                  <p className="text-xs text-text-secondary">{searchResult.email}</p>
                </div>
                <button
                  onClick={() => promote(searchResult)}
                  disabled={busy}
                  className="rounded-lg bg-accent px-3 py-1.5 text-sm font-medium text-background hover:opacity-90 disabled:opacity-60"
                >
                  Make grader
                </button>
              </div>
            )}
          </div>
        </>
      ) : (
        <p className="mt-8 text-sm text-text-secondary">
          Only owners can add team members or change roles.
        </p>
      )}
    </div>
  )
}
