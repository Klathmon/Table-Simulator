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
    builderCard.addEventListener 'zoomed-card-added', ->
      flush ->
        dialogBox = document.querySelector('core-overlay-layer overlay-host').shadowRoot.querySelector 'paper-dialog'
        dialogBox.addEventListener 'core-overlay-open-completed', ->
          computedStyle = window.getComputedStyle dialogBox
          expect(computedStyle.getPropertyValue 'width').to.be.above '10'
          expect(computedStyle.getPropertyValue 'height').to.be.above '10'
          done()

    eventFire builderCard, "dblclick"


suite '<builder-card> Benchmarks', ->
  test 'Create 10 BuilderCards', (done)->
    for x in [0...10]
      builderCard2 = new BuilderCard()
      builderCard2.imageData = img.src
      document.body.appendChild builderCard2
      Polymer.flush()
    done()
