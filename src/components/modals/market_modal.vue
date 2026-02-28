<script setup>
import {ref, inject, computed, onMounted, onUnmounted} from 'vue'
import audio, {playTap} from '@/js/engine/audio.js'
import {formatNumber} from '@/js/engine/format.js'
import {TRADEABLE_RESOURCES} from '@/js/engine/constants.js'
import {MARKET_TRADE_AMOUNT, MARKET_PRICE_SHIFT, MARKET_BASE_FEE, MARKET_MIN_FEE, MARKET_FEE_REDUCTION_PER_LEVEL} from '@/js/engine/balancing.js'
import {IMG_RESOURCE_MAP, SND_MARKET_EXCHANGE} from '@/js/engine/assets.js'
import {RESOURCE_GOLD} from '@/js/engine/enums.js'
import {t} from '@/js/i18n/localized.js'
import ModalHelpModal from '@/components/modals/help_modal.vue'

const emit = defineEmits(['close'])
const colony = inject('colony')
const gameState = inject('gameState')
const visible = ref(false)
const showHelp = ref(false)
let rafId = null

const feePercent = computed(() => Math.round(gameState.effectiveTradeFee() * 100))

function canBuy(resource) {
  return colony.resources.gold >= gameState.buyPrice(resource)
    && colony.resources[resource] + MARKET_TRADE_AMOUNT <= colony.stockpile[resource]
}

function canSell(resource) {
  return colony.resources[resource] >= MARKET_TRADE_AMOUNT
    && colony.resources.gold + gameState.sellPrice(resource) <= colony.stockpile.gold
}

function buyTooltip(resource) {
  if (colony.resources.gold < gameState.buyPrice(resource)) return t('market.notEnoughGold')
  if (colony.resources[resource] + MARKET_TRADE_AMOUNT > colony.stockpile[resource]) return t('market.stockpileFull', t('resource.' + resource).toLowerCase())
  const name = t('resource.' + resource).toLowerCase()
  return t('market.buyTooltip', formatNumber(MARKET_TRADE_AMOUNT), name, formatNumber(gameState.buyPrice(resource)))
}

function sellTooltip(resource) {
  if (colony.resources[resource] < MARKET_TRADE_AMOUNT) return t('market.notEnoughResource', t('resource.' + resource).toLowerCase())
  if (colony.resources.gold + gameState.sellPrice(resource) > colony.stockpile.gold) return t('market.goldStockpileFull')
  const name = t('resource.' + resource).toLowerCase()
  return t('market.sellTooltip', formatNumber(MARKET_TRADE_AMOUNT), name, formatNumber(gameState.sellPrice(resource)))
}

function buy(resource) {
  if (!canBuy(resource)) return
  audio.playSound(SND_MARKET_EXCHANGE)
  gameState.executeTrade(resource, 'buy')
}

function sell(resource) {
  if (!canSell(resource)) return
  audio.playSound(SND_MARKET_EXCHANGE)
  gameState.executeTrade(resource, 'sell')
}

function handleKeydown(event) {
  if (event.key === 'Escape') {
    event.stopImmediatePropagation()
    if (showHelp.value) {
      showHelp.value = false
    } else {
      emit('close')
    }
  }
}

onMounted(() => {
  window.addEventListener('keydown', handleKeydown, true)
  rafId = requestAnimationFrame(() => {
    visible.value = true
  })
})

onUnmounted(() => {
  window.removeEventListener('keydown', handleKeydown, true)
  cancelAnimationFrame(rafId)
})
</script>

<template>
  <div
    class="modal-overlay"
    :class="{ visible }"
    @click.self="emit('close')"
  >
    <div class="market-modal">
      <button class="modal-help-btn" @click="playTap(); showHelp = true">?</button>
      <button class="modal-close-x" @click="playTap(); emit('close')">&#10005;</button>
      <h2 class="modal-title">{{ t('market.title') }}</h2>

      <!-- Resource summary -->
      <div class="market-resources">
        <div
          v-for="resource in TRADEABLE_RESOURCES"
          :key="resource"
          class="resource-box"
        >
          <div class="resource-row-top">
            <img class="resource-icon" :src="IMG_RESOURCE_MAP[resource]" :alt="t('resource.' + resource)">
            <span class="resource-value">{{ formatNumber(colony.resources[resource]) }}</span>
          </div>
        </div>
        <div class="resource-box">
          <div class="resource-row-top">
            <img class="resource-icon" :src="IMG_RESOURCE_MAP[RESOURCE_GOLD]" :alt="t('resource.' + RESOURCE_GOLD)">
            <span class="resource-value">{{ formatNumber(colony.resources[RESOURCE_GOLD]) }}</span>
          </div>
        </div>
      </div>

      <!-- Fee indicator -->
      <div class="market-fee">
        {{ t('market.fee') }}: {{ feePercent }}%
      </div>

      <!-- Column headers -->
      <div class="market-header">
        <span class="market-header-resource" />
        <div class="market-header-actions">
          <span class="market-header-label">{{ t('market.sell') }}</span>
          <span class="market-header-label">{{ t('market.buy') }}</span>
        </div>
      </div>

      <!-- Trade rows -->
      <div class="market-scroll">
        <div
          v-for="resource in TRADEABLE_RESOURCES"
          :key="resource"
          class="trade-row"
        >
          <!-- Resource identity -->
          <div class="trade-resource">
            <img class="trade-resource-icon" :src="IMG_RESOURCE_MAP[resource]" :alt="t('resource.' + resource)">
            <span class="trade-resource-name">{{ t('resource.' + resource) }}</span>
          </div>

          <!-- Trade actions -->
          <div class="trade-actions">
            <!-- Sell -->
            <button
              class="btn-gold trade-btn tooltip"
              :class="{ 'tooltip--delayed': canSell(resource) }"
              :disabled="!canSell(resource)"
              :data-tooltip="sellTooltip(resource)"
              @click="sell(resource)"
            >
              <img class="trade-btn-icon" :src="IMG_RESOURCE_MAP.gold" alt="">
              <span
                class="trade-btn-value trade-btn-value--gain"
                :class="{ 'trade-btn-value--insufficient': colony.resources[resource] < MARKET_TRADE_AMOUNT }"
              >+{{ formatNumber(gameState.sellPrice(resource)) }}</span>
            </button>

            <!-- Buy -->
            <button
              class="btn-gold trade-btn tooltip"
              :class="{ 'tooltip--delayed': canBuy(resource) }"
              :disabled="!canBuy(resource)"
              :data-tooltip="buyTooltip(resource)"
              @click="buy(resource)"
            >
              <img class="trade-btn-icon" :src="IMG_RESOURCE_MAP.gold" alt="">
              <span
                class="trade-btn-value trade-btn-value--cost"
                :class="{ 'trade-btn-value--insufficient': colony.resources.gold < gameState.buyPrice(resource) }"
              >-{{ formatNumber(gameState.buyPrice(resource)) }}</span>
            </button>
          </div>
        </div>
      </div>
    </div>

    <ModalHelpModal
      v-if="showHelp"
      :title="t('modal.marketHelp.title')"
      :body="t('modal.marketHelp.body', MARKET_TRADE_AMOUNT, MARKET_PRICE_SHIFT, MARKET_BASE_FEE * 100, MARKET_FEE_REDUCTION_PER_LEVEL * 100, MARKET_MIN_FEE * 100)"
      @close="showHelp = false"
    />
  </div>
</template>

<style scoped>
/* ── Overlay ─────────────────────────────────────────────── */

.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.75);
  -webkit-backdrop-filter: blur(4px);
  backdrop-filter: blur(4px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 100;
  opacity: 0;
  transition: opacity 0.2s ease;
}

.modal-overlay.visible {
  opacity: 1;
}

/* ── Modal container ─────────────────────────────────────── */

.market-modal {
  position: relative;
  background: var(--color-bg-raised);
  border: 1px solid rgba(var(--color-accent-rgb), 0.2);
  box-shadow:
    0 4px 24px rgba(0, 0, 0, 0.4),
    inset 0 1px 0 rgba(var(--color-accent-rgb), 0.06);
  padding: 1.25rem 2rem 1.75rem;
  width: 90vw;
  max-width: 400px;
  max-height: 89vh;
  display: flex;
  flex-direction: column;
  transform: translateY(8px);
  transition: transform 0.25s ease;
}

.modal-overlay.visible .market-modal {
  transform: translateY(0);
}

/* ── Title ───────────────────────────────────────────────── */

.modal-title {
  font-family: var(--font-display);
  font-weight: 700;
  font-size: 1rem;
  color: var(--color-text);
  letter-spacing: 0.18em;
  text-transform: uppercase;
  align-self: center;
  margin-bottom: 0.75rem;
}

/* ── Resource summary ────────────────────────────────────── */

.market-resources {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 0.5rem;
  padding-top: 1rem;
  margin-bottom: 0.75rem;
}

.market-resources .resource-box {
  flex: 1;
}

.market-resources .resource-box:hover {
  border-color: rgba(var(--color-accent-rgb), 0.1);
  background: rgba(var(--color-accent-rgb), 0.03);
}

.market-resources .resource-value {
  flex: 1;
}

/* ── Fee indicator ───────────────────────────────────────── */

.market-fee {
  font-family: var(--font-numeric);
  font-size: 0.75rem;
  font-weight: 400;
  color: rgba(var(--color-text-rgb), 0.5);
  letter-spacing: 0.04em;
  text-align: center;
  display: inline-block;
  background: rgba(var(--color-accent-rgb), 0.06);
  border: 1px solid rgba(var(--color-accent-rgb), 0.18);
  border-radius: 1rem;
  padding: 0.3rem 0.9rem;
  align-self: center;
  margin-bottom: 2.5rem;
}

/* ── Scrollable area ─────────────────────────────────────── */

.market-scroll {
  display: flex;
  flex-direction: column;
  gap: 0.6rem;
}

/* ── Column headers ──────────────────────────────────────── */

.market-header {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0 0.65rem;
  margin-bottom: 0.5rem;
}

.market-header-resource {
  width: 5rem;
  flex-shrink: 0;
}

.market-header-label {
  font-family: var(--font-display);
  font-size: 0.75rem;
  font-weight: 700;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: rgba(var(--color-text-rgb), 0.5);
  flex: 1;
  text-align: center;
}

/* ── Trade row ───────────────────────────────────────────── */

.trade-row {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.65rem 0.75rem;
  background: rgba(var(--color-accent-rgb), 0.03);
  border: 1px solid rgba(var(--color-accent-rgb), 0.1);
  border-radius: 4px;
}

/* ── Resource identity ───────────────────────────────────── */

.trade-resource {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  width: 5rem;
  flex-shrink: 0;
}

.trade-resource-icon {
  width: 1.15rem;
  height: 1.15rem;
  object-fit: contain;
  filter: drop-shadow(0 0 2px rgba(0, 0, 0, 0.4));
}

.trade-resource-name {
  font-family: var(--font-body);
  font-size: 0.8rem;
  font-weight: 500;
  color: var(--color-text);
}

/* ── Trade action buttons ────────────────────────────────── */

.market-header-actions,
.trade-actions {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  flex: 1;
  max-width: 12rem;
  margin-left: auto;
}

.market-header-label,
.trade-btn {
  flex: 1;
  min-width: 3.5rem;
}

.trade-btn:disabled .trade-btn-value {
  color: rgba(var(--color-text-rgb), 0.25);
}

.trade-btn:disabled::after {
  transition: none;
  opacity: 0;
}

.trade-btn:disabled:hover::after {
  opacity: 1;
}

.trade-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.25rem;
  padding: 0.45rem 0.4rem;
  border-radius: 3px;
}

.trade-btn-icon {
  width: 0.75rem;
  height: 0.75rem;
  object-fit: contain;
  filter: drop-shadow(0 0 1px rgba(0, 0, 0, 0.3));
}

.trade-btn-value {
  font-family: var(--font-numeric);
  font-size: 0.7rem;
  font-weight: 400;
  letter-spacing: 0.02em;
}

.trade-btn-value--gain {
  color: rgba(var(--color-text-rgb), 0.7);
}

.trade-btn-value--cost {
  color: rgba(var(--color-text-rgb), 0.7);
}

.trade-btn-value--insufficient {
  color: rgba(196, 80, 80, 1);
}

</style>
