builderCard = document.querySelector 'builder-card'
img = document.querySelector 'img'
builderCard.imageData = img.src

eventFire = (element, type)->
  if element.fireEvent
    (element.fireEvent('on' + type))
  else
    evObj = document.createEvent('Events')
    evObj.initEvent(type, true, false)
    element.dispatchEvent evObj
  return
window.addEventListener "polymer-ready", ->
  suite '<builder-card>', ->

    test 'check element exists', ->
      expect(builderCard.imageData).to.equal img.src

    test 'check element has layout', ->
      computedStyle = window.getComputedStyle builderCard
      expect(computedStyle.getPropertyValue 'width').to.be.above '10'
      expect(computedStyle.getPropertyValue 'height').to.be.above '10'

    test 'check draggabilly created', ->
      expect(builderCard.draggie).to.be.an.instanceof Draggabilly

    test 'check zoom works', (done)->
      eventFire builderCard, "dblclick"
      setTimeout ->
        dialogBox = document.querySelector 'core-overlay-layer overlay-host'
        computedStyle = window.getComputedStyle dialogBox
        expect(computedStyle.getPropertyValue 'width').to.be.above '10'
        expect(computedStyle.getPropertyValue 'height').to.be.above '10'
        done()
      ,500
