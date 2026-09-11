import { NavLink, Outlet } from 'react-router-dom'
import { useAuth } from '../../contexts/AuthContext'
import { ErrorBoundary } from '../ErrorBoundary'
import { InstallPrompt } from '../InstallPrompt'
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
    <div className="forge-shell flex min-h-svh flex-col bg-background lg:h-svh lg:flex-row lg:overflow-hidden">
      <aside className="hidden shrink-0 flex-col border-r border-border bg-background/85 lg:flex lg:w-64 lg:overflow-y-auto">
        <div className="flex items-center gap-2 px-5 py-5">
          <span className="forge-icon-tile h-9 w-9 rounded-lg"><ForgeMark className="text-accent" size={21} /></span>
          <div>
            <span className="font-heading text-xl leading-none text-text">Forge</span>
            <p className="font-mono text-[10px] uppercase tracking-[.16em] text-text-secondary">student desk</p>
          </div>
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
        <nav className="mt-3 flex flex-col gap-1 px-3" aria-label="Primary">
          {tabs.map(({ to, label, icon: Icon }) => (
            <NavLink
              key={to}
              to={to}
              className={({ isActive }) =>
                `flex items-center gap-3 rounded-xl px-3 py-3 text-sm transition-colors ${
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
        <div className="mt-auto mx-3 mb-4 flex flex-col gap-1 rounded-xl border border-border bg-surface/60 p-2">
          {profile?.full_name && (
            <div className="flex items-center gap-2 px-2 py-1.5">
              <span className="flex h-7 w-7 items-center justify-center rounded-full bg-accent/10 text-xs text-accent">
                {profile.full_name.slice(0, 1).toUpperCase()}
              </span>
              <p className="truncate text-sm text-text-secondary">{profile.full_name}</p>
            </div>
          )}
          <button
            type="button"
            onClick={() => signOut()}
            className="flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-text-secondary hover:bg-background hover:text-text"
          >
            <LogOutIcon size={20} />
            Log out
          </button>
        </div>
      </aside>

      <div className="flex min-w-0 flex-1 flex-col bg-background/80">
        <header className="flex items-center gap-2 border-b border-border bg-background/85 px-4 py-3 lg:hidden">
          <span className="forge-icon-tile h-9 w-9 rounded-lg"><ForgeMark className="text-accent" size={20} /></span>
          <div>
            <span className="font-heading text-xl leading-none text-text">Forge</span>
            <p className="font-mono text-[9px] uppercase tracking-[.14em] text-text-secondary">keep building</p>
          </div>
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
              className="forge-icon-tile h-9 w-9 rounded-lg text-text-secondary hover:text-text"
            >
              <LogOutIcon size={20} />
            </button>
          </div>
        </header>

        <main className="flex-1 pb-24 lg:overflow-y-auto lg:pb-0">
          <div className="mx-auto w-full max-w-5xl">
            <Outlet />
          </div>
        </main>
      </div>

      <nav
        className="fixed inset-x-0 bottom-0 z-10 border-t border-border bg-surface/95 pb-[env(safe-area-inset-bottom)] backdrop-blur lg:hidden"
        aria-label="Primary"
      >
        <ul className="grid grid-cols-5">
          {tabs.map(({ to, label, icon: Icon }) => (
            <li key={to}>
              <NavLink
                to={to}
                className={({ isActive }) =>
                  `flex flex-col items-center gap-1 py-2.5 text-[11px] transition-colors ${
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

      <ErrorBoundary>
        <InstallPrompt />
      </ErrorBoundary>
    </div>
  )
}
