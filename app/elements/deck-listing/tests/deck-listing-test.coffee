suite '<deck-listing>', ->
  addedDeckGUID = ''

  deckListing = document.querySelector 'deck-listing'

  eventFire = (element, type)->
    if element.fireEvent
      (element.fireEvent('on' + type))
    else
      evObj = document.createEvent('Events')
      evObj.initEvent(type, true, false)
      element.dispatchEvent evObj
    return

  suiteSetup (done)->
    localforage.clear(done)
    return

  test 'check element has layout', ->
    computedStyle = window.getComputedStyle deckListing
    expect(computedStyle.getPropertyValue 'width').to.be.above '10'
    expect(computedStyle.getPropertyValue 'height').to.be.above '10'
    return

  test 'add deck button works', (done)->
    eventThing = (deck)->
      deckListing.removeEventListener 'deck-created', eventThing
      expect(deck.guid).to.not.equal ''
      done()
      return

    deckListing.addEventListener 'deck-created', eventThing
    deckListing.addNewDeck()
    return

  test 'check added decks appear in list', (done)->
    eventThing = (deck)->
      deckListing.removeEventListener 'deck-list-updated', eventThing
      animationFrameFlush ->
        setTimeout ->
          paperItem = deckListing.$.deckMenu.querySelectorAll('paper-item')
          expect(paperItem).to.have.length 3
          done()
          return
        , 200
        return
      return

    deckListing.addEventListener 'deck-list-updated', eventThing
    deckListing.addNewDeck()
    return

  test 'check selection works', (done)->
    eventThing2 = (event)->
      deckListing.removeEventListener 'deck-selected', eventThing2
      expect(event.detail.guid).to.equal addedDeckGUID
      done()
      return

    eventThing1 = (event)->
      deckListing.removeEventListener 'deck-created', eventThing1
      addedDeckGUID = event.detail.guid
      element =
        dataset:
          guid: addedDeckGUID
      deckListing.addEventListener 'deck-selected', eventThing2
      deckListing.selectDeck null, null, element
      return

    deckListing.addEventListener 'deck-created', eventThing1
    deckListing.addNewDeck()
    return

  test 'check deletion works', (done)->
    eventThing = ->
      deckListing.removeEventListener 'deck-list-updated', eventThing
      animationFrameFlush ->
        setTimeout ->
          paperItem = deckListing.$.deckMenu.querySelectorAll('paper-item')
          expect(paperItem).to.have.length 3
          done()
          return
        , 200
        return
      return

    deckListing.addEventListener 'deck-list-updated', eventThing
    element =
      dataset:
        guid: addedDeckGUID
    deckListing.deleteDeck null, null, element
    return
  return
