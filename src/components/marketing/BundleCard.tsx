import { Link } from 'react-router-dom'
import type { Bundle } from '../../lib/bundles'
import { formatPrice } from '../../lib/bundles'
import { TechIconCluster } from './TechIconCluster'

export function BundleCard({ bundle }: { bundle: Bundle }) {
  return (
    <Link
      to={`/signup?bundle=${bundle.slug}`}
      className="group flex flex-col gap-4 rounded-2xl border border-border bg-surface p-6 transition-colors hover:border-accent/50"
    >
      <div className="flex items-center justify-between">
        <TechIconCluster slug={bundle.slug} />
        <span className="font-heading text-lg text-text">
          {formatPrice(bundle.price, bundle.currency)}
        </span>
      </div>

      <div>
        <h3 className="font-heading text-xl text-text">{bundle.name}</h3>
        {bundle.description && (
          <p className="mt-1.5 text-sm text-text-secondary">{bundle.description}</p>
        )}
      </div>

      {bundle.audience && (
        <p className="mt-auto text-xs text-text-secondary/80">{bundle.audience}</p>
      )}

      <span className="text-sm font-medium text-accent opacity-0 transition-opacity group-hover:opacity-100">
        Get started →
      </span>
    </Link>
  )
}
