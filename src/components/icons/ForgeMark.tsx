interface ForgeMarkProps {
  className?: string
  size?: number
}

/** Brand mark: single-line diamond with a filled inner spark. */
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
      <path
        d="M16 2 L29 16 L16 30 L3 16 Z"
        stroke="currentColor"
        strokeWidth="2"
        strokeLinejoin="round"
      />
      <path d="M16 12.5 L19.5 16 L16 19.5 L12.5 16 Z" fill="currentColor" />
    </svg>
  )
}
