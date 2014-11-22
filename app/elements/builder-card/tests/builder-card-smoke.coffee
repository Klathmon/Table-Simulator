
builderCard = document.querySelector 'builder-card'
img = document.querySelector 'img'
builderCard.imageData = img.src
img.style.display = "none"
window.addEventListener "polymer-ready", ->
  suite '<builder-card>', ->

    test 'check-element-exists', ->
      expect(builderCard.imageData).to.equal img.src

    test 'check-element-has-layout', ->
      computedStyle = window.getComputedStyle builderCard
      expect(computedStyle.getPropertyValue 'width').to.be.above '10'
      expect(computedStyle.getPropertyValue 'height').to.be.above '10'

    test 'check-draggabilly-created', ->
      expect(builderCard.draggie).to.be.an.instanceof Draggabilly
