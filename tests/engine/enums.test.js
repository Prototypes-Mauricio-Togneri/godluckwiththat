import {describe, it, expect} from 'vitest'
import {RESOURCE_FOOD, RESOURCE_WOOD, RESOURCE_STONE, RESOURCE_COPPER,
  RESOURCE_IRON, RESOURCE_GOLD, RESOURCE_KNOWLEDGE, RESOURCE_FAITH,
  HQ_TYPE_CAMP, HQ_TYPE_SETTLEMENT, HQ_TYPE_VILLAGE, HQ_TYPE_TOWN, HQ_TYPE_CITY,
  SEASON_WARM, SEASON_COLD,
  BUILDING_HEADQUARTERS, BUILDING_FARM, BUILDING_HOUSE, BUILDING_ACADEMY,
  BUILDING_STOREHOUSE, BUILDING_MARKET, BUILDING_WOODCUTTER, BUILDING_QUARRY,
  BUILDING_COPPER_MINE, BUILDING_IRON_MINE, BUILDING_GOLD_MINE,
  BUILDING_ALTAR, BUILDING_TEMPLE, BUILDING_MONUMENT,
  BUILDING_BARRACKS, BUILDING_ARCHERY, BUILDING_STABLE,
  BUILDING_WALL, BUILDING_TOWER,
  TRADE_BUY, TRADE_SELL,
  CHALLENGE_STATUS_PENDING, CHALLENGE_STATUS_ACTIVATED,
  CHALLENGE_STATUS_STARTED, CHALLENGE_STATUS_COMPLETED,
  BLESSING_FERTILE_SOIL, PUNISHMENT_CROP_FAILURE,
  SYMBOL_CHECK, SYMBOL_CROSS} from '@/js/engine/enums.js'

describe('enums', () => {
  describe('resources', () => {
    it('should export all 8 resource enums with correct values', () => {
      expect(RESOURCE_FOOD).toBe('food')
      expect(RESOURCE_WOOD).toBe('wood')
      expect(RESOURCE_STONE).toBe('stone')
      expect(RESOURCE_COPPER).toBe('copper')
      expect(RESOURCE_IRON).toBe('iron')
      expect(RESOURCE_GOLD).toBe('gold')
      expect(RESOURCE_KNOWLEDGE).toBe('knowledge')
      expect(RESOURCE_FAITH).toBe('faith')
    })
  })

  describe('headquarters types', () => {
    it('should export all 5 HQ type enums in progression order', () => {
      expect(HQ_TYPE_CAMP).toBe('camp')
      expect(HQ_TYPE_SETTLEMENT).toBe('settlement')
      expect(HQ_TYPE_VILLAGE).toBe('village')
      expect(HQ_TYPE_TOWN).toBe('town')
      expect(HQ_TYPE_CITY).toBe('city')
    })
  })

  describe('seasons', () => {
    it('should export warm and cold season enums', () => {
      expect(SEASON_WARM).toBe('warm')
      expect(SEASON_COLD).toBe('cold')
    })
  })

  describe('buildings', () => {
    it('should export all 19 building key enums', () => {
      const buildings = [
        BUILDING_HEADQUARTERS,
        BUILDING_HOUSE,
        BUILDING_ACADEMY,
        BUILDING_STOREHOUSE,
        BUILDING_MARKET,
        BUILDING_FARM,
        BUILDING_WOODCUTTER,
        BUILDING_QUARRY,
        BUILDING_COPPER_MINE,
        BUILDING_IRON_MINE,
        BUILDING_GOLD_MINE,
        BUILDING_ALTAR,
        BUILDING_TEMPLE,
        BUILDING_MONUMENT,
        BUILDING_BARRACKS,
        BUILDING_ARCHERY,
        BUILDING_STABLE,
        BUILDING_WALL,
        BUILDING_TOWER,
      ]
      expect(buildings).toHaveLength(19)
      buildings.forEach(building => {
        expect(typeof building).toBe('string')
        expect(building.length).toBeGreaterThan(0)
      })
    })
  })

  describe('trade', () => {
    it('should export buy and sell enums', () => {
      expect(TRADE_BUY).toBe('buy')
      expect(TRADE_SELL).toBe('sell')
    })
  })

  describe('challenge status', () => {
    it('should export all 4 challenge status enums', () => {
      expect(CHALLENGE_STATUS_PENDING).toBe('pending')
      expect(CHALLENGE_STATUS_ACTIVATED).toBe('activated')
      expect(CHALLENGE_STATUS_STARTED).toBe('started')
      expect(CHALLENGE_STATUS_COMPLETED).toBe('completed')
    })
  })

  describe('blessings and punishments', () => {
    it('should export blessing and punishment type enums', () => {
      expect(BLESSING_FERTILE_SOIL).toBe('fertileSoil')
      expect(PUNISHMENT_CROP_FAILURE).toBe('cropFailure')
    })
  })

  describe('symbols', () => {
    it('should export unicode symbols', () => {
      expect(SYMBOL_CHECK).toBe('✓')
      expect(SYMBOL_CROSS).toBe('✕')
    })
  })
})
