<script setup>
import {ref, inject, onMounted, onUnmounted} from 'vue'
import audio, {playTap} from '@/js/engine/audio.js'
import {formatNumber} from '@/js/engine/format.js'
import {TRADEABLE_RESOURCES} from '@/js/engine/constants.js'
import {MARKET_TRADE_AMOUNT, MARKET_PRICE_SHIFT, MARKET_BASE_FEE, MARKET_MIN_FEE, MARKET_FEE_REDUCTION_PER_LEVEL} from '@/js/engine/balancing.js'
import {IMG_RESOURCE_MAP, SND_MARKET_EXCHANGE} from '@/js/engine/assets.js'
import {EMIT_CLOSE, RESOURCE_GOLD, TRADE_BUY, TRADE_SELL} from '@/js/engine/enums.js'
import {t} from '@/js/i18n/localized.js'
import ModalHelpModal from '@/components/modals/help_modal.vue'

const emit = defineEmits([EMIT_CLOSE])
const ui = inject('ui')
const actions = inject('actions')
const visible = ref(false)
const showHelp = ref(false)
let rafId = null

/** Whether the colony can afford to buy this resource without exceeding storage.
 * @param {string} resource - Resource key to check
 * @returns {boolean} True if gold is sufficient and storage has room
 */
function canBuy(resource) {
  return ui.resources.gold >= ui.market.buyPrices[resource]
    && ui.resources[resource] + MARKET_TRADE_AMOUNT <= ui.storageCap
}

/** Whether the colony has enough of this resource to sell without overflowing gold storage.
 * @param {string} resource - Resource key to check
 * @returns {boolean} True if resource amount is sufficient and gold storage has room
 */
function canSell(resource) {
  return ui.resources[resource] >= MARKET_TRADE_AMOUNT
    && ui.resources.gold + ui.market.sellPrices[resource] <= ui.storageCap
}

/** Tooltip text for the buy button, showing cost or the reason the trade is blocked.
 * @param {string} resource - Resource key to generate tooltip for
 * @returns {string} Localized tooltip string
 */
function buyTooltip(resource) {
  if (ui.resources.gold < ui.market.buyPrices[resource]) {
    return t('market.notEnoughGold')
  }
  if (ui.resources[resource] + MARKET_TRADE_AMOUNT > ui.storageCap) {
    return t('market.stockpileFull', t('resource.' + resource).toLowerCase())
  }
  const name = t('resource.' + resource).toLowerCase()
  return t('market.buyTooltip', formatNumber(MARKET_TRADE_AMOUNT), name, formatNumber(ui.market.buyPrices[resource]))
}

/** Tooltip text for the sell button, showing revenue or the reason the trade is blocked.
 * @param {string} resource - Resource key to generate tooltip for
 * @returns {string} Localized tooltip string
 */
function sellTooltip(resource) {
  if (ui.resources[resource] < MARKET_TRADE_AMOUNT) {
    return t('market.notEnoughResource', t('resource.' + resource).toLowerCase())
  }
  if (ui.resources.gold + ui.market.sellPrices[resource] > ui.storageCap) {
    return t('market.goldStockpileFull')
  }
  const name = t('resource.' + resource).toLowerCase()
  return t('market.sellTooltip', formatNumber(MARKET_TRADE_AMOUNT), name, formatNumber(ui.market.sellPrices[resource]))
}

/** Executes a buy trade if affordable, playing the exchange sound effect.
 * @param {string} resource - Resource key to buy
 */
function buy(resource) {
  if (!canBuy(resource)) {
    return
  }
  audio.playSound(SND_MARKET_EXCHANGE)
  actions.executeTrade(resource, TRADE_BUY)
}

/** Executes a sell trade if the colony has enough stock, playing the exchange sound effect.
 * @param {string} resource - Resource key to sell
 */
function sell(resource) {
  if (!canSell(resource)) {
    return
  }
  audio.playSound(SND_MARKET_EXCHANGE)
  actions.executeTrade(resource, TRADE_SELL)
}

/** Handles Escape key to close the help sub-modal first, then the market modal.
 * @param {KeyboardEvent} event - Keyboard event
 */
function handleKeydown(event) {
  if (event.key === 'Escape') {
    event.stopImmediatePropagation()
    if (showHelp.value) {
      showHelp.value = false
    } else {
      emit(EMIT_CLOSE)
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
    @click.self="emit(EMIT_CLOSE)"
  >
    <div class="market-modal">
      <button class="modal-help-btn" @click="playTap(); showHelp = true">?</button>
      <button class="modal-close-x" @click="playTap(); emit(EMIT_CLOSE)">&#10005;</button>
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
            <span class="resource-value">{{ formatNumber(ui.resources[resource]) }}</span>
          </div>
        </div>
        <div class="resource-box">
          <div class="resource-row-top">
            <img class="resource-icon" :src="IMG_RESOURCE_MAP[RESOURCE_GOLD]" :alt="t('resource.' + RESOURCE_GOLD)">
            <span class="resource-value">{{ formatNumber(ui.resources[RESOURCE_GOLD]) }}</span>
          </div>
        </div>
      </div>

      <!-- Fee indicator -->
      <div class="market-fee">
        {{ t('market.fee') }}: {{ ui.market.feePercent }}%
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
                class="trade-btn-value"
                :class="{ 'trade-btn-value--insufficient': ui.resources[resource] < MARKET_TRADE_AMOUNT }"
              >+{{ formatNumber(ui.market.sellPrices[resource]) }}</span>
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
                class="trade-btn-value"
                :class="{ 'trade-btn-value--insufficient': ui.resources.gold < ui.market.buyPrices[resource] }"
              >-{{ formatNumber(ui.market.buyPrices[resource]) }}</span>
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
/* ── Modal container ─────────────────────────────────────── */

.market-modal {
  position: relative;
  background: var(--color-bg-raised);
  border: 1px solid rgba(var(--color-accent-rgb), 0.2);
  box-shadow:
    0 4px 24px rgba(var(--color-shadow-rgb), 0.4),
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

/* Slide-up entrance transition when overlay becomes visible */
.modal-overlay.visible .market-modal {
  transform: translateY(0);
}

/* ── Title ───────────────────────────────────────────────── */

.modal-title {
  font-size: 1rem;
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

/* Subtle accent highlight on resource box hover */
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
  border-radius: 0.25rem;
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
  filter: drop-shadow(0 0 2px rgba(var(--color-shadow-rgb), 0.4));
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

/* Dim the price value when the trade button is disabled */
.trade-btn:disabled .trade-btn-value {
  color: rgba(var(--color-text-rgb), 0.25);
}

/* Hide the tooltip when disabled, skip transition */
.trade-btn:disabled::after {
  transition: none;
  opacity: 0;
}

/* Re-show the tooltip on hover even when disabled */
.trade-btn:disabled:hover::after {
  opacity: 1;
}

.trade-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.25rem;
  padding: 0.45rem 0.4rem;
  border-radius: 0.1875rem;
}

.trade-btn-icon {
  width: 0.75rem;
  height: 0.75rem;
  object-fit: contain;
  filter: drop-shadow(0 0 1px rgba(var(--color-shadow-rgb), 0.3));
}

.trade-btn-value {
  font-family: var(--font-numeric);
  font-size: 0.7rem;
  font-weight: 400;
  letter-spacing: 0.02em;
}

/* Red highlight when the player lacks enough of the required resource */
.trade-btn-value--insufficient {
  color: rgba(196, 80, 80, 1);
}

</style>
