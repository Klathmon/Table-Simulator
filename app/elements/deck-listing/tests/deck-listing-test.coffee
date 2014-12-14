deckListing = document.querySelector 'deck-listing'

eventFire = (element, type)->
  if element.fireEvent
    (element.fireEvent('on' + type))
  else
    evObj = document.createEvent('Events')
    evObj.initEvent(type, true, false)
    element.dispatchEvent evObj
  return

suite '<deck-listing>', ->
  suiteSetup (done)->
    localforage.clear(done)

  test 'check element has layout', ->
    computedStyle = window.getComputedStyle deckListing
    expect(computedStyle.getPropertyValue 'width').to.be.above '10'
    expect(computedStyle.getPropertyValue 'height').to.be.above '10'
    return

  test 'add deck button works', (done)->
    deckListing.addEventListener 'deck-created', (deck)->
      expect(deck.guid).to.not.equal ''
      done()

    deckListing.addNewDeck()
