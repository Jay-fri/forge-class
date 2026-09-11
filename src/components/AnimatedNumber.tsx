import { useEffect, useRef, useState } from 'react'
import { animate } from 'framer-motion'

/**
 * Counts up/down to `value` instead of snapping — used anywhere a stat
 * (streak, badge count, score) first renders, so progress reads as earned
 * rather than just appearing.
 */
export function AnimatedNumber({ value, className }: { value: number; className?: string }) {
  const [display, setDisplay] = useState(0)
  const prev = useRef(0)

  useEffect(() => {
    const controls = animate(prev.current, value, {
      duration: 0.7,
      ease: 'easeOut',
      onUpdate: (v) => setDisplay(Math.round(v)),
    })
    prev.current = value
    return () => controls.stop()
  }, [value])

  return <span className={className}>{display}</span>
}
