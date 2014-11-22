baseCard = document.querySelector 'base-card'
img = document.querySelector 'img'
baseCard.imageData = img.src
img.style.display = "none"
window.addEventListener "polymer-ready", ->
  suite '<base-card>', ->

    test 'check element exists', ->
      expect(baseCard.imageData).to.equal img.src

    test 'check element has layout', ->
      computedStyle = window.getComputedStyle baseCard
      expect(computedStyle.getPropertyValue 'width').to.be.above '10'
      expect(computedStyle.getPropertyValue 'height').to.be.above '10'

    test 'check zoom works', (done)->
      baseCard.zoomCard()
      setTimeout ->
        dialogBox = document.querySelector 'core-overlay-layer overlay-host'
        computedStyle = window.getComputedStyle dialogBox
        expect(computedStyle.getPropertyValue 'width').to.be.above '10'
        expect(computedStyle.getPropertyValue 'height').to.be.above '10'
        done()
      ,500
