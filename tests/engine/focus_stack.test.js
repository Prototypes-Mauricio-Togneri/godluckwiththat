import {describe, it, expect, vi, beforeEach, afterEach} from 'vitest'
import {pushFocusLayer, removeFocusLayer} from '@/js/engine/focus_stack.js'

/** Minimal DOM element stand-in with a parent, children, attributes and a focus spy.
 * @param {Object|null} parent - Parent element to append to
 * @returns {Object} Fake element
 */
function createElement(parent = null) {
  const attributes = new Set()
  const element = {
    parentElement: parent,
    children: [],
    isConnected: true,
    focus: vi.fn(),
    setAttribute: name => attributes.add(name),
    removeAttribute: name => attributes.delete(name),
    hasAttribute: name => attributes.has(name),
  }
  if (parent) {
    parent.children.push(element)
  }
  return element
}

const observers = [] // Every fake observer created; the module keeps its first one across tests

/** MutationObserver stand-in that records its observed targets; addChild reports added children to it. */
class FakeMutationObserver {
  constructor(callback) {
    this.callback = callback // Called when an observed target gains a child
    this.targets = new Set() // Elements currently observed
    observers.push(this)
  }

  /** Starts watching the target's children.
   * @param {Object} target - Fake element to watch
   */
  observe(target) {
    this.targets.add(target)
  }

  /** Stops watching every target. */
  disconnect() {
    this.targets.clear()
  }
}

/** Appends a new element and notifies the observers watching its parent, as the browser would.
 * @param {Object} parent - Fake element to append to
 * @returns {Object} The new element
 */
function addChild(parent) {
  const element = createElement(parent)
  for (const observer of observers) {
    if (observer.targets.has(parent)) {
      observer.callback([])
    }
  }
  return element
}

describe('focus stack', () => {
  let pushed
  let page

  beforeEach(() => {
    // html > body > [app > screen > [header, main > card > [cardContent, buildingHelp], pause, settings], script]
    const html = createElement()
    const body = createElement(html)
    const app = createElement(body)
    const script = createElement(body)
    const screen = createElement(app)
    const header = createElement(screen)
    const main = createElement(screen)
    const card = createElement(main)
    const cardContent = createElement(card)
    const buildingHelp = createElement(card)
    const pause = createElement(screen)
    const settings = createElement(screen)
    page = {
      html: html,
      body: body,
      app: app,
      script: script,
      screen: screen,
      header: header,
      main: main,
      card: card,
      cardContent: cardContent,
      buildingHelp: buildingHelp,
      pause: pause,
      settings: settings,
    }
    vi.stubGlobal('document', {
      body: body,
      activeElement: body,
    })
    vi.stubGlobal('window', {
      MutationObserver: FakeMutationObserver,
    })
    pushed = []
  })

  afterEach(() => {
    for (const element of pushed) {
      removeFocusLayer(element)
    }
    vi.unstubAllGlobals()
  })

  /** Pushes an element and tracks it for cleanup.
   * @param {Object} element - Fake element to push
   */
  function push(element) {
    pushed.push(element)
    pushFocusLayer(element)
  }

  /** Names of the fake page elements currently marked inert.
   * @returns {string[]} Sorted element names
   */
  function inertNames() {
    return Object.keys(page).filter(name => page[name].hasAttribute('inert')).sort()
  }

  it('should mark everything outside the modal inert, but not the modal or its ancestors', () => {
    push(page.pause)
    expect(inertNames()).toEqual([
      'header',
      'main',
      'script',
      'settings',
    ])
  })

  it('should leave <head> and <html> alone by stopping at <body>', () => {
    const head = createElement(page.html)
    push(page.pause)
    expect(head.hasAttribute('inert')).toBe(false)
    expect(page.html.hasAttribute('inert')).toBe(false)
  })

  it('should make a modal underneath inert while another modal is on top', () => {
    push(page.pause)
    push(page.settings)
    expect(inertNames()).toEqual([
      'header',
      'main',
      'pause',
      'script',
    ])
  })

  it('should give input back to the previous modal once the top one is removed', () => {
    push(page.pause)
    push(page.settings)
    removeFocusLayer(page.settings)
    expect(inertNames()).toEqual([
      'header',
      'main',
      'script',
      'settings',
    ])
  })

  it('should keep the top modal in effect when a lower one is removed', () => {
    push(page.pause)
    push(page.settings)
    removeFocusLayer(page.pause)
    expect(inertNames()).toEqual([
      'header',
      'main',
      'pause',
      'script',
    ])
  })

  it('should restore the whole page once the last modal is removed', () => {
    push(page.pause)
    removeFocusLayer(page.pause)
    expect(inertNames()).toEqual([])
  })

  it('should keep the ancestors of a nested modal interactive and mark their siblings inert', () => {
    push(page.buildingHelp)
    expect(inertNames()).toEqual([
      'cardContent',
      'header',
      'pause',
      'script',
      'settings',
    ])
  })

  it('should mark elements added beside the modal or its ancestors after it opened', () => {
    push(page.buildingHelp)
    const unlockedCard = addChild(page.main)
    const cardBadge = addChild(page.card)
    expect(unlockedCard.hasAttribute('inert')).toBe(true)
    expect(cardBadge.hasAttribute('inert')).toBe(true)
  })

  it('should stop watching for added elements once the last modal is removed', () => {
    push(page.pause)
    removeFocusLayer(page.pause)
    const banner = addChild(page.screen)
    expect(banner.hasAttribute('inert')).toBe(false)
  })

  it('should give focus back to the element focused before the modal opened', () => {
    document.activeElement = page.header
    push(page.pause)
    removeFocusLayer(page.pause)
    expect(page.header.focus).toHaveBeenCalledOnce()
  })

  it('should give focus back inside the modal underneath when the top one closes', () => {
    const settingsButton = createElement(page.pause)
    document.activeElement = page.header
    push(page.pause)
    document.activeElement = settingsButton
    push(page.settings)
    removeFocusLayer(page.settings)
    expect(settingsButton.focus).toHaveBeenCalledOnce()
    expect(page.header.focus).not.toHaveBeenCalled()
  })

  it('should leave focus alone when a modal underneath closes', () => {
    document.activeElement = page.header
    push(page.pause)
    push(page.settings)
    removeFocusLayer(page.pause)
    expect(page.header.focus).not.toHaveBeenCalled()
  })

  it('should not give focus back to an element that left the page', () => {
    document.activeElement = page.header
    push(page.pause)
    page.header.isConnected = false
    removeFocusLayer(page.pause)
    expect(page.header.focus).not.toHaveBeenCalled()
  })

  it('should not clear inert on elements it did not mark', () => {
    page.header.setAttribute('inert', '')
    push(page.pause)
    removeFocusLayer(page.pause)
    expect(inertNames()).toEqual(['header'])
  })

  it('should ignore removing an element that was never pushed', () => {
    push(page.pause)
    removeFocusLayer(page.settings)
    expect(inertNames()).toEqual([
      'header',
      'main',
      'script',
      'settings',
    ])
  })
})
