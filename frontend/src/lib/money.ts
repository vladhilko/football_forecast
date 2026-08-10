export function creditsFromMinor(minor: number): string {
  return (minor / 100).toLocaleString('en-US', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  })
}

export function minorFromCredits(credits: string): number | null {
  if (!/^\d+(?:\.\d{0,2})?$/.test(credits.trim())) return null
  const minor = Math.round(Number(credits) * 100)
  return Number.isSafeInteger(minor) ? minor : null
}
