deckBuilder = document.querySelector 'deck-builder'
img1 = document.querySelector '#img1'
img2 = document.querySelector '#img2'

addCardToDeckSorter = (imgElement)->
  deckBuilder.$.imageUploader.importFile imgElement.src, 'image/jpg'

suite '<deck-builder> Decks', ->
  suiteSetup (done)->
    deckBuilder.$.dataStorage.purgeEverything().then ->
      done()
  test 'check add deck works', (done)->
    deckBuilder.addNewDeck()
    animationFrameFlush ->
      expect(deckBuilder.currentDeck.name).to.equal 'Unnamed Deck'
      setTimeout ->
        done()
      , 100

  test 'check deck listing works', (done)->
    eventCount = 0
    tempEvent = ->
      eventCount++
      if eventCount is 1
        deckBuilder.removeEventListener 'decklist-updated', tempEvent
        animationFrameFlush ->
          setTimeout ->
            expect(deckBuilder.$.deckMenu.querySelectorAll('paper-item')).to.have.length 3
            done()
          , 100
    deckBuilder.addEventListener 'decklist-updated', tempEvent
    deckBuilder.addNewDeck()

  test 'check deck renaming works', (done)->
    eventCount = 0
    tempEvent = ->
      eventCount++
      if eventCount is 1
        deckBuilder.removeEventListener 'deck-renamed', tempEvent
        animationFrameFlush ->
          expect(deckBuilder.currentDeck.name).to.equal 'Named Deck'
          done()
    deckBuilder.addEventListener 'deck-renamed', tempEvent
    event =
      value: "Named Deck"
    deckBuilder.deckNameOnBlur(null, null, event)

  test 'check deck selection works', (done)->
    tempEvent = ->
      deckBuilder.removeEventListener 'deck-loaded', tempEvent
      animationFrameFlush ->
        expect(deckBuilder.currentDeck.name).to.equal 'Unnamed Deck'
        done()
    currentDeckGUID = deckBuilder.currentDeck.guid
    paperElements = deckBuilder.$.deckMenu.querySelectorAll('paper-item')
    if paperElements[0].dataset.guid is currentDeckGUID
      element = paperElements[1]
    else
      element = paperElements[0]
    expect(element.dataset.guid).to.not.equal currentDeckGUID
    deckBuilder.addEventListener 'deck-loaded', tempEvent
    deckBuilder.loadDeck null, null, element

  test 'check deck deletion works', (done)->
    eventCount = 0
    eventCount2 = 0
    eventCount3 = 0
    tempEvent3 = ->
      eventCount3++
      if eventCount3 is 2
        deckBuilder.removeEventListener 'layout-complete', tempEvent3
        animationFrameFlush ->
          expect(deckBuilder.$.deckSorter.querySelectorAll 'builder-card').to.have.length 0
          done()
    tempEvent2 = ->
      eventCount2++
      if eventCount2 is 1
        deckBuilder.removeEventListener 'decklist-updated', tempEvent2
        animationFrameFlush ->
          expect(deckBuilder.currentDeck).to.be.null
          expect(deckBuilder.$.deckMenu.querySelectorAll('paper-item')).to.have.length 2
    tempEvent = ->
      eventCount++
      if eventCount is 2
        deckBuilder.removeEventListener 'deck-saved', tempEvent
        deckBuilder.addEventListener 'decklist-updated', tempEvent2
        deckBuilder.addEventListener 'layout-complete', tempEvent3
        animationFrameFlush ->
          expect(deckBuilder.currentDeck).to.not.be.null
          expect(deckBuilder.$.deckMenu.querySelectorAll('paper-item')).to.have.length 3
          deckBuilder.deleteDeck()

    deckBuilder.addEventListener 'deck-saved', tempEvent
    addCardToDeckSorter img1
