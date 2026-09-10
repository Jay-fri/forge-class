import { NavLink, Outlet } from 'react-router-dom'
import { useAuth } from '../../contexts/AuthContext'
import { ErrorBoundary } from '../ErrorBoundary'
import { NotificationBell } from '../notifications/NotificationBell'
import {
  BookIcon,
  CodeIcon,
  ForgeMark,
  HomeIcon,
  LogOutIcon,
  SearchIcon,
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
 * Bottom tab nav on phone/tablet, max 5 items, no hamburger menu — per the
 * brand's navigation spec. On laptop/desktop the same 5 items become a
 * persistent left rail instead (still no hamburger, just more room to use).
 * Primary action buttons on individual pages stay fixed above the bottom
 * bar on mobile, thumb-reachable.
 */
export function StudentShell() {
  const { profile, signOut } = useAuth()

  return (
    <div className="flex min-h-svh flex-col bg-background lg:flex-row">
      <aside className="hidden shrink-0 flex-col border-r border-border lg:flex lg:w-56">
        <div className="flex items-center gap-2 px-5 py-4">
          <ForgeMark className="text-accent" size={22} />
          <span className="font-heading text-lg text-text">Forge</span>
          <div className="ml-auto flex items-center gap-3">
            <NavLink
              to="/search"
              aria-label="Search"
              className={({ isActive }) =>
                `text-text-secondary hover:text-text ${isActive ? 'text-accent' : ''}`
              }
            >
              <SearchIcon size={19} />
            </NavLink>
            <ErrorBoundary>
              <NotificationBell />
            </ErrorBoundary>
          </div>
        </div>
        <nav className="flex flex-col gap-1 px-3" aria-label="Primary">
          {tabs.map(({ to, label, icon: Icon }) => (
            <NavLink
              key={to}
              to={to}
              className={({ isActive }) =>
                `flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm transition-colors ${
                  isActive
                    ? 'bg-accent/10 text-accent'
                    : 'text-text-secondary hover:bg-surface hover:text-text'
                }`
              }
            >
              <Icon size={20} />
              {label}
            </NavLink>
          ))}
        </nav>
        <div className="mt-auto flex flex-col gap-1 px-3 pb-4">
          {profile?.full_name && (
            <p className="truncate px-2 py-2 text-sm text-text-secondary">
              {profile.full_name}
            </p>
          )}
          <button
            type="button"
            onClick={() => signOut()}
            className="flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-text-secondary hover:bg-surface hover:text-text"
          >
            <LogOutIcon size={20} />
            Log out
          </button>
        </div>
      </aside>

      <div className="flex min-w-0 flex-1 flex-col">
        <header className="flex items-center gap-2 border-b border-border px-4 py-3 lg:hidden">
          <ForgeMark className="text-accent" size={22} />
          <span className="font-heading text-lg text-text">Forge</span>
          <div className="ml-auto flex items-center gap-3">
            <NavLink
              to="/search"
              aria-label="Search"
              className={({ isActive }) =>
                `text-text-secondary hover:text-text ${isActive ? 'text-accent' : ''}`
              }
            >
              <SearchIcon size={20} />
            </NavLink>
            <ErrorBoundary>
              <NotificationBell />
            </ErrorBoundary>
            <button
              type="button"
              onClick={() => signOut()}
              aria-label="Log out"
              className="text-text-secondary hover:text-text"
            >
              <LogOutIcon size={20} />
            </button>
          </div>
        </header>

        <main className="flex-1 overflow-y-auto pb-24 lg:pb-0">
          <div className="mx-auto w-full max-w-3xl">
            <Outlet />
          </div>
        </main>
      </div>

      <nav
        className="fixed inset-x-0 bottom-0 z-10 border-t border-border bg-surface pb-[env(safe-area-inset-bottom)] lg:hidden"
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
