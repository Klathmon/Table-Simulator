deckBuilder = document.querySelector 'deck-builder'
img1 = document.querySelector '#img1'
img2 = document.querySelector '#img2'

addCardToDeckSorter = (imgElement)->
  deckBuilder.$.imageUploader.importFile imgElement.src, 'image/jpg'

eventFire = (element, type)->
  if element.fireEvent
    (element.fireEvent('on' + type))
  else
    evObj = document.createEvent('Events')
    evObj.initEvent(type, true, false)
    element.dispatchEvent evObj
  return

suite '<deck-builder> Cards', ->
  suiteSetup (done)->
    deckBuilder.$.dataStorage.purgeEverything().then ->
      done()

  test 'check card buttons are enabled after first card selected', (done)->
    eventCount = 0
    eventCount2 = 0
    tempEvent2 = ->
      eventCount2++
      if eventCount2 is 1
        deckBuilder.removeEventListener 'checkbox-changed', tempEvent2
        animationFrameFlush ->
          expect(deckBuilder.$.deleteCardsButton.hasAttribute 'disabled').to.be.false
          expect(deckBuilder.$.copyCardsButton.hasAttribute 'disabled').to.be.false
          done()
    tempEvent = ->
      eventCount++
      if eventCount is 3
        animationFrameFlush ->
          deckBuilder.removeEventListener 'deck-saved', tempEvent
          deckBuilder.addEventListener 'checkbox-changed', tempEvent2
          deckBuilder.$.deckSorter.querySelector('builder-card').$.checkbox.setAttribute 'checked', true

    deckBuilder.addEventListener 'deck-saved', tempEvent
    expect(deckBuilder.$.deleteCardsButton.hasAttribute 'disabled').to.be.true
    expect(deckBuilder.$.copyCardsButton.hasAttribute 'disabled').to.be.true
    deckBuilder.addNewDeck()
    addCardToDeckSorter img1

  test 'check delete card button works', (done)->
    eventCount = 0
    eventCount2 = 0
    tempEvent2 = ->
      eventCount2++
      if eventCount2 is 2
        deckBuilder.removeEventListener 'layout-complete', tempEvent2
        animationFrameFlush ->
          expect(deckBuilder.$.deckSorter.querySelectorAll('builder-card')).to.have.length 1
          expect(deckBuilder.$.deleteCardsButton.hasAttribute 'disabled').to.be.true
          done()
    tempEvent = ->
      eventCount++
      if eventCount is 1
        deckBuilder.removeEventListener 'deck-saved', tempEvent
        animationFrameFlush ->
          deckBuilder.addEventListener 'layout-complete', tempEvent2
          expect(deckBuilder.$.deleteCardsButton.hasAttribute 'disabled').to.be.false
          deckBuilder.deleteSelectedCards()
    deckBuilder.addEventListener 'deck-saved', tempEvent
    addCardToDeckSorter img2
    return

  test 'check copying 2 copies of a card to another deck works', (done)->
    eventCount = 0
    eventCount2 = 0
    eventCount3 = 0
    tempEvent3 = ->
      eventCount3++
      if eventCount3 is 1
        deckBuilder.removeEventListener 'deck-saved', tempEvent3
        animationFrameFlush ->
          expect(deckBuilder.$.deckSorter.querySelectorAll('builder-card.checked')).to.have.length 0
          expect(deckBuilder.$.copyCardsButton.hasAttribute 'disabled').to.be.true
          deckBuilder.$.dataStorage.getDeck(deck1guid).then (deck)->
            expect(deck.cards).to.have.length 2
            done()
      return
    tempEvent2 = ->
      eventCount2++
      if eventCount2 is 1
        deckBuilder.removeEventListener 'checkbox-changed', tempEvent2
        animationFrameFlush ->
          deckBuilder.addEventListener 'deck-saved', tempEvent3
          deckBuilder.numberToCopy = 2
          deckBuilder.deckToCopyTo = deck1guid
          deckBuilder.copySelectedCards()
    tempEvent = ->
      eventCount++
      if eventCount is 5
        deckBuilder.removeEventListener 'deck-saved', tempEvent
        animationFrameFlush ->
          deckBuilder.addEventListener 'checkbox-changed', tempEvent2
          deckBuilder.$.deckSorter.querySelector('builder-card').$.checkbox.setAttribute 'checked', true
    deckBuilder.addEventListener 'deck-saved', tempEvent
    deckBuilder.addNewDeck()
    deck1guid = deckBuilder.currentDeck.guid
    deckBuilder.addNewDeck()
    addCardToDeckSorter img1
    addCardToDeckSorter img2

  test 'check copying 2 copies of a card to the current deck works', (done)->
    eventCount = 0
    eventCount2 = 0
    eventCount3 = 0
    tempEvent3 = ->
      eventCount3++
      if eventCount3 is 1
        deckBuilder.removeEventListener 'deck-saved', tempEvent3
        animationFrameFlush ->
          expect(deckBuilder.$.deckSorter.querySelectorAll('builder-card.checked')).to.have.length 0
          expect(deckBuilder.$.copyCardsButton.hasAttribute 'disabled').to.be.true
          expect(deckBuilder.$.deckSorter.querySelectorAll('builder-card')).to.have.length 4
          done()
      return
    tempEvent2 = ->
      eventCount2++
      if eventCount2 is 1
        deckBuilder.removeEventListener 'checkbox-changed', tempEvent2
        animationFrameFlush ->
          deckBuilder.addEventListener 'deck-saved', tempEvent3
          deckBuilder.numberToCopy = 2
          deckBuilder.deckToCopyTo = deckBuilder.currentDeck.guid
          deckBuilder.copySelectedCards()
    tempEvent = ->
      eventCount++
      if eventCount is 5
        deckBuilder.removeEventListener 'deck-saved', tempEvent
        animationFrameFlush ->
          deckBuilder.addEventListener 'checkbox-changed', tempEvent2
          deckBuilder.$.deckSorter.querySelector('builder-card').$.checkbox.setAttribute 'checked', true
    deckBuilder.addEventListener 'deck-saved', tempEvent
    deckBuilder.addNewDeck()
    deckBuilder.addNewDeck()
    addCardToDeckSorter img1
    addCardToDeckSorter img2

    return
