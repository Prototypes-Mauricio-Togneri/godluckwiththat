import {describe, it, expect, vi, beforeEach, afterEach} from 'vitest'
import {pushEscapeHandler, removeEscapeHandler} from '@/js/engine/escape_stack.js'

/** Minimal window stand-in that records keydown listeners.
 * @returns {Object} Fake window with add/remove listener methods and the registered listeners
 */
function createWindow() {
  const listeners = new Set()
  return {
    listeners: listeners,
    addEventListener: (_, listener) => listeners.add(listener),
    removeEventListener: (_, listener) => listeners.delete(listener),
  }
}

/** Sends a keydown event to every registered listener.
 * @param {string} key - Key value
 * @returns {Object} The dispatched event, with a spy for stopImmediatePropagation
 */
function pressKey(key) {
  const event = {
    key: key,
    stopImmediatePropagation: vi.fn(),
  }
  for (const listener of window.listeners) {
    listener(event)
  }
  return event
}

describe('escape stack', () => {
  let pushed

  beforeEach(() => {
    vi.stubGlobal('window', createWindow())
    pushed = []
  })

  afterEach(() => {
    for (const handler of pushed) {
      removeEscapeHandler(handler)
    }
    vi.unstubAllGlobals()
  })

  /** Pushes a handler and tracks it for cleanup.
   * @returns {Function} The pushed mock handler
   */
  function push() {
    const handler = vi.fn()
    pushed.push(handler)
    pushEscapeHandler(handler)
    return handler
  }

  it('should call only the most recently pushed handler and stop the event', () => {
    const bottom = push()
    const top = push()
    const event = pressKey('Escape')
    expect(top).toHaveBeenCalledOnce()
    expect(bottom).not.toHaveBeenCalled()
    expect(event.stopImmediatePropagation).toHaveBeenCalledOnce()
  })

  it('should give Escape back to the previous handler once the top one is removed', () => {
    const bottom = push()
    const top = push()
    removeEscapeHandler(top)
    pressKey('Escape')
    expect(bottom).toHaveBeenCalledOnce()
    expect(top).not.toHaveBeenCalled()
  })

  it('should keep the top handler when a lower one is removed', () => {
    const bottom = push()
    const top = push()
    removeEscapeHandler(bottom)
    pressKey('Escape')
    expect(top).toHaveBeenCalledOnce()
  })

  it('should ignore keys other than Escape', () => {
    const top = push()
    const event = pressKey('Enter')
    expect(top).not.toHaveBeenCalled()
    expect(event.stopImmediatePropagation).not.toHaveBeenCalled()
  })

  it('should register a single window listener and detach it when the last handler is removed', () => {
    const bottom = push()
    const top = push()
    expect(window.listeners.size).toBe(1)
    removeEscapeHandler(top)
    removeEscapeHandler(bottom)
    expect(window.listeners.size).toBe(0)
  })

  it('should ignore removing a handler that was never pushed', () => {
    const top = push()
    removeEscapeHandler(vi.fn())
    pressKey('Escape')
    expect(top).toHaveBeenCalledOnce()
  })
})
