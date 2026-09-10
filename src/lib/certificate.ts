// Canvas-rendered certificate — a simple downloadable image, per the brand
// doc's "Deferred / future" note this stays a PNG, not a PDF pipeline.

export async function generateCertificate({
  studentName,
  trackName,
  date,
}: {
  studentName: string
  trackName: string
  date: Date
}): Promise<Blob> {
  await Promise.all([
    document.fonts.load('700 64px "Indie Flower"'),
    document.fonts.load('400 28px "Pangolin"'),
    document.fonts.load('400 20px "Pangolin"'),
  ])

  const width = 1400
  const height = 1000
  const canvas = document.createElement('canvas')
  canvas.width = width
  canvas.height = height
  const ctx = canvas.getContext('2d')!

  const background = '#0e1210'
  const surface = '#171c19'
  const border = '#232a24'
  const accent = '#d9a75c'
  const text = '#f1f0ea'
  const textSecondary = '#9ba79b'

  ctx.fillStyle = background
  ctx.fillRect(0, 0, width, height)

  // Outer + inner border frame
  ctx.strokeStyle = border
  ctx.lineWidth = 2
  ctx.strokeRect(40, 40, width - 80, height - 80)
  ctx.strokeStyle = accent
  ctx.lineWidth = 1.5
  ctx.strokeRect(64, 64, width - 128, height - 128)

  ctx.fillStyle = surface
  ctx.fillRect(64, 64, width - 128, height - 128)

  // Forge mark: diamond with inner spark, matches the app logo
  const cx = width / 2
  let y = 175
  ctx.strokeStyle = accent
  ctx.lineWidth = 3
  ctx.beginPath()
  ctx.moveTo(cx, y - 32)
  ctx.lineTo(cx + 32, y)
  ctx.lineTo(cx, y + 32)
  ctx.lineTo(cx - 32, y)
  ctx.closePath()
  ctx.stroke()
  ctx.fillStyle = accent
  ctx.beginPath()
  ctx.moveTo(cx, y - 10)
  ctx.lineTo(cx + 10, y)
  ctx.lineTo(cx, y + 10)
  ctx.lineTo(cx - 10, y)
  ctx.closePath()
  ctx.fill()

  ctx.textAlign = 'center'
  ctx.fillStyle = textSecondary
  ctx.font = '400 22px Pangolin, sans-serif'
  ctx.fillText('FORGE', cx, y + 60)

  ctx.fillStyle = textSecondary
  ctx.font = '400 24px Pangolin, sans-serif'
  ctx.fillText('Certificate of Completion', cx, y + 130)

  ctx.fillStyle = text
  ctx.font = '700 64px "Indie Flower", cursive'
  ctx.fillText(studentName, cx, y + 240)

  ctx.fillStyle = textSecondary
  ctx.font = '400 24px Pangolin, sans-serif'
  ctx.fillText('has completed', cx, y + 300)

  ctx.fillStyle = accent
  ctx.font = '700 42px "Indie Flower", cursive'
  wrapCenteredText(ctx, trackName, cx, y + 360, width - 300, 52)

  ctx.fillStyle = textSecondary
  ctx.font = '400 20px Pangolin, sans-serif'
  ctx.fillText(
    date.toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' }),
    cx,
    height - 120,
  )

  return new Promise((resolve, reject) => {
    canvas.toBlob((blob) => (blob ? resolve(blob) : reject(new Error('Canvas export failed'))), 'image/png')
  })
}

function wrapCenteredText(
  ctx: CanvasRenderingContext2D,
  text: string,
  cx: number,
  startY: number,
  maxWidth: number,
  lineHeight: number,
) {
  const words = text.split(' ')
  let line = ''
  const lines: string[] = []
  for (const word of words) {
    const test = line ? `${line} ${word}` : word
    if (ctx.measureText(test).width > maxWidth && line) {
      lines.push(line)
      line = word
    } else {
      line = test
    }
  }
  if (line) lines.push(line)
  lines.forEach((l, i) => ctx.fillText(l, cx, startY + i * lineHeight))
}

export function downloadBlob(blob: Blob, filename: string) {
  const url = URL.createObjectURL(blob)
  const a = document.createElement('a')
  a.href = url
  a.download = filename
  a.click()
  URL.revokeObjectURL(url)
}
