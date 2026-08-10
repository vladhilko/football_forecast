import { describe, expect, it } from 'vitest'
import { creditsFromMinor, minorFromCredits } from './money'

describe('credit money helpers', () => {
  it('formats integer minor units without floating-point drift', () => {
    expect(creditsFromMinor(1_001_099)).toBe('10,010.99')
  })

  it('accepts at most two decimal places', () => {
    expect(minorFromCredits('100.25')).toBe(10_025)
    expect(minorFromCredits('100.255')).toBeNull()
  })
})
