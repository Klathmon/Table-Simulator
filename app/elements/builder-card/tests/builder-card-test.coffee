suite '<builder-card>', ->
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


  test 'check element exists', ->
    expect(builderCard.imageData).to.equal img.src
    return

  test 'check element has layout', ->
    computedStyle = window.getComputedStyle builderCard
    expect(computedStyle.getPropertyValue 'width').to.be.above '10'
    expect(computedStyle.getPropertyValue 'height').to.be.above '10'
    return

  test 'check draggabilly created', ->
    expect(builderCard.draggie).to.be.an.instanceof Draggabilly
    return

  test 'check zoom works', (done)->
    builderCard.addEventListener 'zoomed-card-added', ->
      flush ->
        overlayHost = document.querySelector('core-overlay-layer overlay-host')
        dialogBox = overlayHost.shadowRoot.querySelector 'paper-dialog'
        dialogBox.addEventListener 'core-overlay-open-completed', ->
          computedStyle = window.getComputedStyle dialogBox
          expect(computedStyle.getPropertyValue 'width').to.be.above '10'
          expect(computedStyle.getPropertyValue 'height').to.be.above '10'
          done()
          return
        return
      return

    eventFire builderCard, 'dblclick'
    return
  return
