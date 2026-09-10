import { Link } from 'react-router-dom'

export function Breadcrumbs({
  items,
}: {
  items: { label: string; to?: string }[]
}) {
  return (
    <nav className="mb-4 flex flex-wrap items-center gap-1.5 text-sm text-text-secondary">
      {items.map((item, i) => (
        <span key={i} className="flex items-center gap-1.5">
          {i > 0 && <span className="text-text-secondary/50">/</span>}
          {item.to ? (
            <Link to={item.to} className="hover:text-text hover:underline">
              {item.label}
            </Link>
          ) : (
            <span className="text-text">{item.label}</span>
          )}
        </span>
      ))}
    </nav>
  )
}
