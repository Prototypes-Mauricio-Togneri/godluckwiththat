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
