import { useState } from 'react'
import { NavLink, Outlet } from 'react-router-dom'
import { useAuth } from '../../contexts/AuthContext'
import {
  BookIcon,
  CalendarIcon,
  CheckCircleIcon,
  ChevronLeftIcon,
  ClipboardIcon,
  ForgeMark,
  HomeIcon,
  InboxIcon,
  LogOutIcon,
  MenuIcon,
  MessageIcon,
  PriceTagIcon,
  QuestionIcon,
  ShieldIcon,
  TrendingIcon,
  UsersIcon,
} from '../icons'

const navItems = [
  { to: '/admin', label: 'Home', icon: HomeIcon, end: true },
  { to: '/admin/approvals', label: 'Approvals', icon: InboxIcon, end: false },
  { to: '/admin/cohorts', label: 'Cohorts', icon: CalendarIcon, end: false },
  { to: '/admin/students', label: 'Students', icon: UsersIcon, end: false },
  { to: '/admin/bundles', label: 'Bundles & Pricing', icon: PriceTagIcon, end: false },
  { to: '/admin/curriculum', label: 'Curriculum', icon: BookIcon, end: false },
  { to: '/admin/grading', label: 'Grading', icon: CheckCircleIcon, end: false },
  { to: '/admin/discussions', label: 'Questions', icon: QuestionIcon, end: false },
  { to: '/admin/content-feedback', label: 'Content Feedback', icon: MessageIcon, end: false },
  { to: '/admin/analytics', label: 'Analytics', icon: TrendingIcon, end: false },
  { to: '/admin/audit-log', label: 'Audit Log', icon: ClipboardIcon, end: false },
  { to: '/admin/team', label: 'Team', icon: ShieldIcon, end: false },
]

/**
 * Collapsible sidebar shell for the instructor/admin dashboard — denser
 * than the student app, same design system. Full nav (Approvals, Cohorts,
 * Grading, etc.) is filled in across Phase 6.
 */
export function InstructorShell() {
  const { profile, signOut } = useAuth()
  const [collapsed, setCollapsed] = useState(false)
  const [mobileOpen, setMobileOpen] = useState(false)

  return (
    <div className="flex min-h-svh bg-background">
      {mobileOpen && (
        <button
          type="button"
          aria-label="Close menu"
          onClick={() => setMobileOpen(false)}
          className="fixed inset-0 z-20 bg-black/60 md:hidden"
        />
      )}

      <aside
        className={`fixed inset-y-0 left-0 z-30 flex flex-col border-r border-border bg-surface transition-all duration-200 md:static ${
          collapsed ? 'md:w-[76px]' : 'md:w-64'
        } ${mobileOpen ? 'w-64 translate-x-0' : '-translate-x-full md:translate-x-0'}`}
      >
        <div className="flex items-center gap-2 px-4 py-4">
          <ForgeMark className="shrink-0 text-accent" size={22} />
          {!collapsed && <span className="font-heading text-lg text-text">Forge</span>}
          <button
            type="button"
            onClick={() => setCollapsed((c) => !c)}
            className="ml-auto hidden text-text-secondary hover:text-text md:block"
            aria-label={collapsed ? 'Expand sidebar' : 'Collapse sidebar'}
          >
            <ChevronLeftIcon
              size={18}
              className={`transition-transform ${collapsed ? 'rotate-180' : ''}`}
            />
          </button>
        </div>

        <nav className="flex-1 px-2">
          <ul className="flex flex-col gap-1">
            {navItems.map(({ to, label, icon: Icon, end }) => (
              <li key={to}>
                <NavLink
                  to={to}
                  end={end}
                  onClick={() => setMobileOpen(false)}
                  className={({ isActive }) =>
                    `flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm transition-colors ${
                      isActive
                        ? 'bg-accent/10 text-accent'
                        : 'text-text-secondary hover:bg-background hover:text-text'
                    }`
                  }
                >
                  <Icon size={20} />
                  {!collapsed && label}
                </NavLink>
              </li>
            ))}
          </ul>
        </nav>

        <div className="border-t border-border p-3">
          <div className="flex items-center gap-2 px-1 pb-2 text-xs text-text-secondary">
            <ShieldIcon size={16} />
            {!collapsed && 'Instructor'}
          </div>
          <button
            type="button"
            onClick={() => signOut()}
            className="flex w-full items-center gap-3 rounded-lg px-3 py-2.5 text-sm text-text-secondary hover:bg-background hover:text-text"
          >
            <LogOutIcon size={20} />
            {!collapsed && 'Log out'}
          </button>
        </div>
      </aside>

      <div className="flex min-h-svh flex-1 flex-col">
        <header className="flex items-center gap-3 border-b border-border px-4 py-3 md:hidden">
          <button
            type="button"
            onClick={() => setMobileOpen(true)}
            aria-label="Open menu"
            className="text-text-secondary"
          >
            <MenuIcon size={22} />
          </button>
          <span className="font-heading text-lg text-text">Forge</span>
          {profile?.full_name && (
            <span className="ml-auto text-sm text-text-secondary">
              {profile.full_name}
            </span>
          )}
        </header>

        <main className="flex-1 overflow-y-auto">
          <Outlet />
        </main>
      </div>
    </div>
  )
}
