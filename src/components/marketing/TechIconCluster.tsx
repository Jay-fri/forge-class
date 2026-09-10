import type { ComponentType } from 'react'
import {
  SiCss,
  SiExpress,
  SiHtml5,
  SiJavascript,
  SiNodedotjs,
  SiPhp,
  SiPostgresql,
  SiPython,
  SiReact,
} from '@icons-pack/react-simple-icons'

type TechIcon = ComponentType<{ size?: number; color?: string; title?: string }>

// Technology marks are intentionally official and colored: students should
// immediately recognize the languages and frameworks represented by a path.
const techBySlug: Record<string, TechIcon[]> = {
  frontend: [SiHtml5, SiCss, SiReact],
  backend: [SiNodedotjs, SiExpress, SiPostgresql],
  'full-stack': [SiReact, SiNodedotjs],
  python: [SiPython],
  javascript: [SiJavascript],
  php: [SiPhp],
}

export function TechIconCluster({
  slug,
  size = 18,
  chip = 40,
}: {
  slug: string
  size?: number
  chip?: number
}) {
  const icons = techBySlug[slug] ?? []

  return (
    <div className="flex -space-x-2">
      {icons.map((Icon, i) => (
        <span
          key={i}
          className="flex items-center justify-center rounded-full border-2 border-surface bg-text"
          style={{ zIndex: icons.length - i, width: chip, height: chip }}
        >
          <Icon size={size} color="default" />
        </span>
      ))}
    </div>
  )
}
