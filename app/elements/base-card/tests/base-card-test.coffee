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


  suite '<base-card> Benchmarks', ->
      startTime = performance.now()
      baseCard2 = new BaseCard()
      baseCard2.imageData = img.src
      document.body.appendChild baseCard2
      Polymer.flush()
      endTime = performance.now()
      test('BaseCard took ' + parseFloat(endTime - startTime).toFixed(2) + 'ms to create')
