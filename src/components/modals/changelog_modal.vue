<script setup>
import {ref, onMounted, onUnmounted} from 'vue'
import {marked} from 'marked'
import {playTap} from '@/js/engine/audio.js'
import {EMIT_CLOSE} from '@/js/engine/enums.js'
import {pushEscapeHandler, removeEscapeHandler} from '@/js/engine/escape_stack.js'
import {t} from '@/js/i18n/localized.js'
import changelogRaw from '@/assets/changelog.md?raw'

/** Strip any inline HTML tags from the markdown source to prevent XSS. */
const sanitizedMarkdown = changelogRaw.replace(/<[^>]*>/g, '')

const emit = defineEmits([EMIT_CLOSE])
const visible = ref(false)
let rafId = null

const changelogHtml = marked(sanitizedMarkdown)

/** Closes modal on Escape while it is the topmost modal. */
function handleEscape() {
  emit(EMIT_CLOSE)
}

onMounted(() => {
  pushEscapeHandler(handleEscape)
  rafId = requestAnimationFrame(() => {
    visible.value = true
  })
})

onUnmounted(() => {
  removeEscapeHandler(handleEscape)
  cancelAnimationFrame(rafId)
})
</script>

<template>
  <div
    class="modal-overlay"
    :class="{ visible }"
    @click.self="emit(EMIT_CLOSE)"
  >
    <div class="modal-content">
      <h2 class="modal-title">{{ t('modal.changelog.title') }}</h2>
      <span class="modal-rule" />
      <!-- eslint-disable-next-line vue/no-v-html -- static bundled asset, HTML-stripped before parsing -->
      <div class="changelog-body thin-scrollbar" v-html="changelogHtml" />

      <button class="btn-gold modal-btn" @click="playTap(); emit(EMIT_CLOSE)">
        {{ t('modal.help.close') }}
      </button>
    </div>
  </div>
</template>

<style scoped>
.modal-content {
  padding: 1.75rem 2rem 1.5rem;
  min-width: 340px;
  max-width: 540px;
  max-height: 80vh;
}

.modal-rule {
  display: block;
  margin: 0.75rem auto 1.25rem;
}

/* Scrollable rendered markdown container */
.changelog-body {
  overflow-y: auto;
  max-height: 50vh;
  padding: 0.5rem 0.75rem;
  font-family: var(--font-body);
  font-size: 0.95rem;
  font-weight: 300;
  line-height: 1.6;
  text-align: justify;
  color: rgba(var(--color-text-rgb), 0.75);
}

/* Version headings */
.changelog-body :deep(h2) {
  font-family: var(--font-display);
  font-size: 1.1rem;
  font-weight: 700;
  color: var(--color-text);
  letter-spacing: 0.08em;
  margin-top: 1.25rem;
  margin-bottom: 0.5rem;
}

.changelog-body :deep(h2:first-child) {
  margin-top: 0;
}

/* Section headings within a version */
.changelog-body :deep(h3) {
  font-family: var(--font-display);
  font-size: 0.95rem;
  font-weight: 600;
  color: rgba(var(--color-text-rgb), 0.85);
  letter-spacing: 0.05em;
  margin-top: 1rem;
  margin-bottom: 0.4rem;
}

.changelog-body :deep(ul) {
  padding-left: 1.2rem;
  margin-bottom: 0.75rem;
}

.changelog-body :deep(li) {
  margin-bottom: 0.3rem;
}

.changelog-body :deep(p) {
  margin-bottom: 0.5rem;
}

.changelog-body :deep(strong) {
  font-weight: 600;
  color: rgba(var(--color-text-rgb), 0.9);
}

.modal-btn {
  margin-top: 1.5rem;
  align-self: stretch;
}
</style>
