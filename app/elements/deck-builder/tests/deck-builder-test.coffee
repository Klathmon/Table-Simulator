deckBuilder = document.querySelector 'deck-builder'
img = document.querySelector 'img'
img.style.display = "none"
window.addEventListener "polymer-ready", ->
  suite '<deck-builder>', ->

    test 'check element has layout', ->
      computedStyle = window.getComputedStyle deckBuilder
      expect(computedStyle.getPropertyValue 'width').to.be.above '10'
      expect(computedStyle.getPropertyValue 'height').to.be.above '10'
