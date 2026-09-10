import { Link } from 'react-router-dom'
import type { Bundle } from '../../lib/bundles'
import { formatPrice } from '../../lib/bundles'
import { TechIconCluster } from './TechIconCluster'

export function BundleCard({ bundle }: { bundle: Bundle }) {
  return (
    <Link
      to={`/signup?bundle=${bundle.slug}`}
      className="forge-card group flex min-h-64 flex-col gap-5 p-5 transition-all hover:-translate-y-1 hover:border-accent/60 sm:p-6"
    >
      <div className="flex items-center justify-between">
        <TechIconCluster slug={bundle.slug} />
        <span className="rounded-full border border-accent/30 bg-accent/5 px-3 py-1 font-heading text-lg text-accent">
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

      <span className="text-sm font-medium text-accent transition-transform group-hover:translate-x-1">
        Start this path →
      </span>
    </Link>
  )
}
