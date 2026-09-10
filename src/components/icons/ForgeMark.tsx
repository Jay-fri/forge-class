interface ForgeMarkProps {
  className?: string
  size?: number
}

/**
 * Forge's maker's mark: a forged hexagon containing a cut-out F and an
 * upward spark. It stays legible at favicon scale but has enough character
 * to carry a larger brand lockup.
 */
export function ForgeMark({ className, size = 28 }: ForgeMarkProps) {
  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 32 32"
      fill="none"
      className={className}
      role="img"
      aria-label="Forge"
    >
      <path d="M16 2.75 27.5 9.3v13.4L16 29.25 4.5 22.7V9.3L16 2.75Z" stroke="currentColor" strokeWidth="1.8" strokeLinejoin="round" />
      <path d="M10 9h10v3.25h-6.25v2.45h5.25v3.1h-5.25V23H10V9Z" fill="currentColor" />
      <path d="M23.1 5.15v3.1M21.55 6.7h3.1" stroke="currentColor" strokeWidth="1.55" strokeLinecap="round" />
    </svg>
  )
}
