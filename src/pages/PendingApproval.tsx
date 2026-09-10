import { useEffect, useState } from 'react'
import { useAuth } from '../contexts/AuthContext'
import { supabase } from '../lib/supabase'
import { formatPrice } from '../lib/bundles'
import { BookIcon, ForgeMark, MessageIcon } from '../components/icons'
import { Markdown } from '../components/content/Markdown'

const WHATSAPP_NUMBER = '2348101593762'

interface PreviewSection {
  title: string | null
  content: string | null
}

export function PendingApproval() {
  const { profile, signOut } = useAuth()
  const [bundleName, setBundleName] = useState<string | null>(null)
  const [bundlePrice, setBundlePrice] = useState<string | null>(null)
  const [preview, setPreview] = useState<PreviewSection | null>(null)

  useEffect(() => {
    if (profile?.assigned_bundle_id) {
      supabase
        .from('bundles')
        .select('name, price, currency')
        .eq('id', profile.assigned_bundle_id)
        .single()
        .then(({ data }) => {
          if (!data) return
          setBundleName(data.name)
          setBundlePrice(formatPrice(data.price, data.currency))
        })
    }

    supabase
      .from('sections')
      .select('title, content, lessons!inner(is_free_preview)')
      .eq('lessons.is_free_preview', true)
      .order('order_index')
      .limit(1)
      .then(({ data }) => {
        if (data?.[0]) setPreview(data[0])
      })
  }, [profile?.assigned_bundle_id])

  const message = encodeURIComponent(
    bundleName
      ? `Hi! I just signed up for the ${bundleName} bundle (${bundlePrice}) on Forge and I'd like to arrange payment.`
      : "Hi! I just signed up on Forge and I'd like to arrange payment.",
  )

  return (
    <div className="forge-auth min-h-svh bg-background px-5 py-8 sm:px-8 sm:py-14">
      <div className="forge-card--accent forge-card mx-auto flex max-w-xl flex-col items-center p-6 text-center sm:p-10">
        <span className="forge-icon-tile h-14 w-14"><ForgeMark className="text-accent" size={31} /></span>
        <p className="page-kicker mt-5">One last step</p><h1 className="mt-2 font-heading text-4xl text-text">
          Your account is pending approval
        </h1>
        <p className="mt-3 text-text-secondary">
          Message us on WhatsApp to arrange payment
          {bundleName ? ` for ${bundleName} (${bundlePrice})` : ''}. We'll
          unlock your bundle and send the class WhatsApp group invite as soon
          as it's confirmed.
        </p>

        <a
          href={`https://wa.me/${WHATSAPP_NUMBER}?text=${message}`}
          target="_blank"
          rel="noopener noreferrer"
          className="forge-button mt-7 gap-2 px-5 py-3"
        >
          <MessageIcon size={18} />
          Message us on WhatsApp
        </a>

        <button
          type="button"
          onClick={() => signOut()}
          className="mt-6 text-sm text-text-secondary hover:text-text hover:underline"
        >
          Log out
        </button>
      </div>

      {preview && (
        <div className="mx-auto mt-10 max-w-2xl">
          <div className="mb-4 flex items-center gap-2">
            <span className="h-px flex-1 bg-border" />
            <span className="text-xs uppercase tracking-wide text-text-secondary">
              While you wait, try a free lesson
            </span>
            <span className="h-px flex-1 bg-border" />
          </div>

          <div className="forge-card p-5 sm:p-7">
            <div className="mb-4 flex items-center gap-2 text-accent"><span className="forge-icon-tile h-9 w-9"><BookIcon size={17} /></span><p className="forge-panel-label">Preview lesson</p></div>
            {preview.title && (
              <h2 className="mb-3 font-heading text-xl text-text">{preview.title}</h2>
            )}
            {preview.content && <Markdown>{preview.content}</Markdown>}
          </div>
        </div>
      )}
    </div>
  )
}
