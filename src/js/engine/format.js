import {t} from '@/js/i18n/localized.js'

const NUMBER_SUFFIXES = [
  '',
  'K',
  'M',
  'B',
  'T',
]

/**
 * Formats seconds as MM:SS or HH:MM:SS (hours only when >= 3600s).
 * @param {number} totalSeconds
 * @returns {string}
 */
export function formatTime(totalSeconds) {
  const seconds = Math.ceil(totalSeconds)
  const hours = Math.floor(seconds / 3600)
  const minutes = Math.floor((seconds % 3600) / 60)
  const secs = seconds % 60
  const pad = n => String(n).padStart(2, '0')
  if (hours > 0) return `${pad(hours)}:${pad(minutes)}:${pad(secs)}`
  return `${pad(minutes)}:${pad(secs)}`
}

/**
 * Abbreviates large numbers with K/M/B/T suffixes.
 * @param {number} n
 * @returns {string}
 */
export function formatNumber(n) {
  const floored = Math.floor(n)
  if (floored < 1000) return String(floored)
  const tier = Math.min(Math.floor(Math.log10(floored) / 3), NUMBER_SUFFIXES.length - 1)
  const scaled = floored / Math.pow(1000, tier)
  const fixed = (Math.floor(scaled * 10) / 10).toFixed(1)
  const short = fixed.endsWith('.0') ? fixed.slice(0, -2) : fixed
  return short + NUMBER_SUFFIXES[tier]
}

/**
 * Formats a per-second rate as a display string with unit suffix.
 * @param {number} ratePerSecond
 * @returns {string}
 */
export function formatRate(ratePerSecond) {
  const value = Math.round(ratePerSecond * 10) / 10
  if (value > 0) return `${value.toFixed(1)}${t('resource.perSecond')}`
  if (value < 0) return `-${Math.abs(value).toFixed(1)}${t('resource.perSecond')}`
  return `0.0${t('resource.perSecond')}`
}
