import { NavLink, Outlet } from 'react-router-dom'
import { useAuth } from '../../contexts/AuthContext'
import {
  BookIcon,
  CodeIcon,
  ForgeMark,
  HomeIcon,
  SparkleIcon,
  TrendingIcon,
} from '../icons'

const tabs = [
  { to: '/home', label: 'Home', icon: HomeIcon },
  { to: '/learn', label: 'Learn', icon: BookIcon },
  { to: '/practice', label: 'Practice', icon: CodeIcon },
  { to: '/progress', label: 'Progress', icon: TrendingIcon },
  { to: '/ask-ai', label: 'Ask AI', icon: SparkleIcon },
]

/**
 * Bottom tab nav, max 5 items, no hamburger menu — per the brand's
 * navigation spec. Primary action buttons on individual pages stay
 * fixed above this bar, thumb-reachable.
 */
export function StudentShell() {
  const { profile } = useAuth()

  return (
    <div className="flex min-h-svh flex-col bg-background">
      <header className="flex items-center gap-2 border-b border-border px-4 py-3">
        <ForgeMark className="text-accent" size={22} />
        <span className="font-heading text-lg text-text">Forge</span>
        {profile?.full_name && (
          <span className="ml-auto text-sm text-text-secondary">
            {profile.full_name}
          </span>
        )}
      </header>

      <main className="flex-1 overflow-y-auto pb-24">
        <Outlet />
      </main>

      <nav
        className="fixed inset-x-0 bottom-0 z-10 border-t border-border bg-surface pb-[env(safe-area-inset-bottom)]"
        aria-label="Primary"
      >
        <ul className="grid grid-cols-5">
          {tabs.map(({ to, label, icon: Icon }) => (
            <li key={to}>
              <NavLink
                to={to}
                className={({ isActive }) =>
                  `flex flex-col items-center gap-1 py-2.5 text-xs transition-colors ${
                    isActive ? 'text-accent' : 'text-text-secondary'
                  }`
                }
              >
                <Icon size={22} />
                {label}
              </NavLink>
            </li>
          ))}
        </ul>
      </nav>
    </div>
  )
}
