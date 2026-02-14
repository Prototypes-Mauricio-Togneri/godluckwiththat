/**
 * Scans public/img/ and generates src/js/engine/assets.js with named constants
 * for every image file. Run via: npm run generate-assets
 */

import {readdirSync, statSync, writeFileSync} from 'node:fs'
import {basename, dirname, extname, join, relative} from 'node:path'
import {fileURLToPath} from 'node:url'

const ROOT = join(dirname(fileURLToPath(import.meta.url)), '..')
const IMG_DIR = join(ROOT, 'public', 'img')
const OUTPUT = join(ROOT, 'src', 'js', 'engine', 'assets.js')

// Group display names keyed by directory path relative to img/
const GROUP_LABELS = {
  resources: 'Resources',
  'buildings/misc': 'Buildings — misc',
  'buildings/religious': 'Buildings — religious',
  'buildings/resources': 'Buildings — resources',
  'buildings/military': 'Buildings — military',
  units: 'Units',
  ico: 'Icons',
  other: 'Other',
  seasons: 'Seasons',
}

/**
 * Recursively collects all files under a directory.
 * Returns paths relative to the base directory.
 */
function collectFiles(dir, base = dir) {
  const entries = readdirSync(dir).sort()
  const files = []
  for (const entry of entries) {
    const full = join(dir, entry)
    if (statSync(full).isDirectory()) {
      files.push(...collectFiles(full, base))
    } else {
      files.push(relative(base, full))
    }
  }
  return files
}

/**
 * Derives a constant name from a path relative to img/.
 * e.g. "resources/food.png" → "IMG_RESOURCE_FOOD"
 *      "buildings/misc/academy.png" → "IMG_BUILDING_ACADEMY"
 */
function toConstantName(relPath) {
  const withoutExt = relPath.replace(extname(relPath), '')
  const parts = withoutExt.split('/')

  // For buildings/subfolder/name, drop the subfolder
  if (parts[0] === 'buildings' && parts.length === 3) {
    parts.splice(1, 1)
  }

  // Singularize first segment (remove trailing 's')
  if (parts[0].endsWith('s')) {
    parts[0] = parts[0].slice(0, -1)
  }

  return 'IMG_' + parts.join('_').toUpperCase()
}

/**
 * Returns the group key for a file path (directory relative to img/).
 * e.g. "resources/food.png" → "resources"
 *      "buildings/misc/academy.png" → "buildings/misc"
 */
function groupKey(relPath) {
  const parts = relPath.split('/')
  // For buildings, group by subfolder
  if (parts[0] === 'buildings' && parts.length === 3) {
    return parts[0] + '/' + parts[1]
  }
  return parts[0]
}

// Collect and group files
const allFiles = collectFiles(IMG_DIR)
const groups = new Map()

for (const file of allFiles) {
  const key = groupKey(file)
  if (!groups.has(key)) groups.set(key, [])
  groups.get(key).push(file)
}

// Build output
const lines = ['// Asset path constants — centralized references to all public image files.']
const resourceEntries = []

for (const [
  dirKey,
  label,
] of Object.entries(GROUP_LABELS)) {
  const files = groups.get(dirKey)
  if (!files || files.length === 0) continue

  lines.push('')
  lines.push(`// ${label}`)
  for (const file of files) {
    const name = toConstantName(file)
    const imgPath = '/img/' + file
    lines.push(`export const ${name} = '${imgPath}'`)

    if (dirKey === 'resources') {
      const key = basename(file, extname(file))
      resourceEntries.push({
        key,
        name,
      })
    }
  }
}

// Resource map
if (resourceEntries.length > 0) {
  lines.push('')
  lines.push('// Resource image lookup by key (for dynamic :src bindings)')
  lines.push('export const IMG_RESOURCE_MAP = {')
  for (const {
    key,
    name,
  } of resourceEntries) {
    lines.push(`  ${key}: ${name},`)
  }
  lines.push('}')
}

lines.push('')

writeFileSync(OUTPUT, lines.join('\n'))
console.log(`Generated ${OUTPUT} (${allFiles.length} assets)`)
