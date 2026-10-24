// Battle math — pure, deterministic functions shared by the raid forecast and the raid resolution.

import {RAID_DEFEAT_MAX_LEVELS, RAID_DEFEAT_MAX_RESOURCES, RAID_DEFEAT_MAX_WORKERS, TOWER_ARCHERS_PER_LEVEL, UNIT_COUNTER_MULTIPLIER, UNIT_STATS, WALL_HEALTH_PER_LEVEL} from '@/js/engine/balancing.js'
import {UNIT_COUNTERS, UNIT_TYPES} from '@/js/engine/constants.js'
import {UNIT_ARCHER} from '@/js/engine/enums.js'

/**
 * Health of each unit type in an army.
 * @param {Object<string, number>} units - Unit count per type
 * @param {number} defenseBonus - Fractional health bonus from research (0 for raiders)
 * @returns {Object<string, number>} Health per unit type
 */
function healthByType(units, defenseBonus) {
  const health = {}
  for (const type of UNIT_TYPES) {
    health[type] = (units[type] ?? 0) * UNIT_STATS[type].health * (1 + defenseBonus)
  }
  return health
}

/**
 * Share of an army's unit health held by each unit type.
 * @param {Object<string, number>} units - Unit count per type
 * @param {number} defenseBonus - Fractional health bonus from research
 * @returns {Object<string, number>} Share (0–1) per unit type; all 0 for an empty army
 */
function healthShares(units, defenseBonus) {
  const health = healthByType(units, defenseBonus)
  const total = armyHealth(units, defenseBonus)
  const shares = {}
  for (const type of UNIT_TYPES) {
    shares[type] = total > 0 ? health[type] / total : 0
  }
  return shares
}

/**
 * Attack multiplier of a unit type against an opponent. Grows with the share of the
 * opponent's unit health made of the type it beats, up to UNIT_COUNTER_MULTIPLIER.
 * @param {string} type - Attacking unit type
 * @param {Object<string, number>} opponentShares - Opponent health share per unit type
 * @returns {number} Multiplier between 1 and UNIT_COUNTER_MULTIPLIER
 */
function counterFactor(type, opponentShares) {
  return 1 + (UNIT_COUNTER_MULTIPLIER - 1) * opponentShares[UNIT_COUNTERS[type]]
}

/**
 * Total health of an army's units (the wall is not included).
 * @param {Object<string, number>} units - Unit count per type
 * @param {number} [defenseBonus=0] - Fractional health bonus from research
 * @returns {number} Summed unit health
 */
export function armyHealth(units, defenseBonus = 0) {
  const health = healthByType(units, defenseBonus)
  let total = 0
  for (const type of UNIT_TYPES) {
    total += health[type]
  }
  return total
}

/**
 * Total attack of an army's units against an opponent, counter bonuses included (the tower is not included).
 * @param {Object<string, number>} units - Unit count per type
 * @param {number} attackBonus - Fractional attack bonus from research (0 for raiders)
 * @param {Object<string, number>} opponentUnits - Opponent unit count per type
 * @param {number} [opponentDefenseBonus=0] - Opponent's fractional health bonus
 * @returns {number} Summed attack
 */
export function armyAttack(units, attackBonus, opponentUnits, opponentDefenseBonus = 0) {
  const opponentShares = healthShares(opponentUnits, opponentDefenseBonus)
  let total = 0
  for (const type of UNIT_TYPES) {
    total += (units[type] ?? 0) * UNIT_STATS[type].attack * (1 + attackBonus) * counterFactor(type, opponentShares)
  }
  return total
}

/**
 * Resolves a raid in one step by comparing both sides' power (attack × health, Lanchester square law).
 * The defender's wall adds health that soaks losses first and is never damaged; the tower adds attack
 * as a fixed number of archers per level and never dies. Research bonuses apply to defender units only.
 *
 * | Fight                            | Ratio | Result                   |
 * |----------------------------------|-------|--------------------------|
 * | 10 infantry vs 9 infantry        | 1.11  | Victory, 6 infantry lost |
 * | Same, plus a level 1 wall        | 1.28  | Victory, 2 infantry lost |
 * | 10 archers vs 10 infantry        | 1.41  | Victory                  |
 * | No units and no tower            | 0     | Defeat at severity 1     |
 *
 * @param {Object} defender - The colony's side
 * @param {Object<string, number>} defender.units - Unit count per type
 * @param {number} defender.wallLevel - Wall level
 * @param {number} defender.towerLevel - Tower level
 * @param {number} defender.attackBonus - Fractional unit attack bonus
 * @param {number} defender.defenseBonus - Fractional unit health bonus
 * @param {number} defender.workers - Colony worker total (for the workers lost on defeat)
 * @param {Object} attacker - The raiders
 * @param {Object<string, number>} attacker.units - Unit count per type
 * @returns {{victory: boolean, ratio: number, playerPower: number, enemyPower: number, unitsLost: Object<string, number>, severity: number, resourceShare: number, workersLost: number, levelsLost: number}}
 *   Outcome; ratio > 1 is a victory, severity (0–1) scales the defeat losses
 */
export function resolveBattle(defender, attacker) {
  const {
    units, wallLevel, towerLevel, attackBonus, defenseBonus, workers,
  } = defender
  const enemyShares = healthShares(attacker.units, 0)

  const unitHealth = armyHealth(units, defenseBonus)
  const wallHealth = wallLevel * WALL_HEALTH_PER_LEVEL
  const towerAttack = towerLevel * TOWER_ARCHERS_PER_LEVEL * UNIT_STATS[UNIT_ARCHER].attack * counterFactor(UNIT_ARCHER, enemyShares)
  const playerAttack = armyAttack(units, attackBonus, attacker.units, 0) + towerAttack
  const playerPower = playerAttack * (unitHealth + wallHealth)
  const enemyPower = armyAttack(attacker.units, 0, units, defenseBonus) * armyHealth(attacker.units, 0)

  const unitsLost = {}
  for (const type of UNIT_TYPES) {
    unitsLost[type] = 0
  }
  const victoryResult = {
    victory: true,
    playerPower: playerPower,
    enemyPower: enemyPower,
    unitsLost: unitsLost,
    severity: 0,
    resourceShare: 0,
    workersLost: 0,
    levelsLost: 0,
  }

  // No raiders to fight (cannot normally happen)
  if (enemyPower === 0) {
    return {
      ...victoryResult,
      ratio: Infinity,
    }
  }

  const ratio = Math.sqrt(playerPower / enemyPower)

  if (ratio > 1) {
    // The wall soaks the lost health first; units lose the rest in proportion to their numbers
    const lossShare = 1 - Math.sqrt(Math.max(0, 1 - 1 / (ratio * ratio)))
    const healthLost = lossShare * (unitHealth + wallHealth)
    const absorbed = Math.min(healthLost, wallHealth)
    for (const type of UNIT_TYPES) {
      const count = units[type] ?? 0
      unitsLost[type] = unitHealth > 0 ? Math.min(count, Math.round(count * (healthLost - absorbed) / unitHealth)) : 0
    }
    return {
      ...victoryResult,
      ratio: ratio,
    }
  }

  // Defeat: the whole army is lost; other losses scale from 0 (near tie) to 1 (no defense)
  const severity = Math.sqrt(Math.max(0, 1 - ratio * ratio))
  for (const type of UNIT_TYPES) {
    unitsLost[type] = units[type] ?? 0
  }
  return {
    victory: false,
    ratio: ratio,
    playerPower: playerPower,
    enemyPower: enemyPower,
    unitsLost: unitsLost,
    severity: severity,
    resourceShare: severity * RAID_DEFEAT_MAX_RESOURCES,
    workersLost: Math.round(severity * RAID_DEFEAT_MAX_WORKERS * workers),
    levelsLost: Math.round(severity * RAID_DEFEAT_MAX_LEVELS),
  }
}
