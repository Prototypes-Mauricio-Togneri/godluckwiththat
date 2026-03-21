import {describe, it, expect, vi} from 'vitest'

vi.mock('@/js/i18n/localized.js', () => ({
  t: (key) => key,
}))

const {
  formatTime,
  formatNumber,
  formatNumberFull,
  formatMinutes,
  formatRate,
} = await import('@/js/engine/format.js')

describe('formatTime', () => {
  it('should format seconds as MM:SS', () => {
    expect(formatTime(65)).toBe('01:05')
  })

  it('should format 0 seconds', () => {
    expect(formatTime(0)).toBe('00:00')
  })

  it('should use HH:MM:SS when >= 3600 seconds', () => {
    expect(formatTime(3661)).toBe('01:01:01')
  })

  it('should ceil fractional seconds', () => {
    expect(formatTime(0.1)).toBe('00:01')
  })

  it('should pad single digits', () => {
    expect(formatTime(5)).toBe('00:05')
  })
})

describe('formatNumber', () => {
  it('should return string for small numbers', () => {
    expect(formatNumber(42)).toBe('42')
    expect(formatNumber(999)).toBe('999')
  })

  it('should abbreviate thousands with K', () => {
    expect(formatNumber(1000)).toBe('1K')
    expect(formatNumber(1500)).toBe('1.5K')
  })

  it('should abbreviate millions with M', () => {
    expect(formatNumber(1000000)).toBe('1M')
    expect(formatNumber(2500000)).toBe('2.5M')
  })

  it('should abbreviate billions with B', () => {
    expect(formatNumber(1000000000)).toBe('1B')
  })

  it('should handle negative numbers', () => {
    expect(formatNumber(-1500)).toBe('-1.5K')
  })

  it('should floor the number', () => {
    expect(formatNumber(999.9)).toBe('999')
  })

  it('should handle 0', () => {
    expect(formatNumber(0)).toBe('0')
  })
})

describe('formatNumberFull', () => {
  it('should format with locale separators', () => {
    const result = formatNumberFull(1234567)
    expect(result).toContain('1')
    expect(result).toContain('234')
    expect(result).toContain('567')
  })

  it('should floor the number', () => {
    const result = formatNumberFull(99.9)
    expect(result).toBe('99')
  })
})

describe('formatMinutes', () => {
  it('should return singular key for 1 minute', () => {
    expect(formatMinutes(60)).toBe('1 time.minute')
  })

  it('should return plural key for multiple minutes', () => {
    expect(formatMinutes(300)).toBe('5 time.minutes')
  })

  it('should round to nearest minute', () => {
    expect(formatMinutes(89)).toBe('1 time.minute')
    expect(formatMinutes(90)).toBe('2 time.minutes')
  })
})

describe('formatRate', () => {
  it('should format zero as 0.0/s', () => {
    expect(formatRate(0)).toBe('0.0resource.perSecond')
  })

  it('should format positive rate', () => {
    const result = formatRate(1.5)
    expect(result).toBe('1.5resource.perSecond')
  })

  it('should format negative rate with sign', () => {
    const result = formatRate(-0.5)
    expect(result).toBe('-0.5resource.perSecond')
  })

  it('should strip trailing zero from decimals', () => {
    const result = formatRate(1.1)
    expect(result).toBe('1.1resource.perSecond')
  })

  it('should round to 2 decimal places', () => {
    const result = formatRate(0.123)
    expect(result).toBe('0.12resource.perSecond')
  })
})
