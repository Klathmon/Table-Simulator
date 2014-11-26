deckBuilder = document.querySelector 'deck-builder'
img = document.querySelector 'img'
img.style.display = "none"
timeoutTime = 500
window.addEventListener "polymer-ready", ->
  suite '<deck-builder>', ->
    setup (done)->
      deckBuilder.$.dataStorage.purgeEverything().then ->
        done()

    test 'check element has layout', ->
      computedStyle = window.getComputedStyle deckBuilder
      expect(computedStyle.getPropertyValue 'width').to.be.above '10'
      expect(computedStyle.getPropertyValue 'height').to.be.above '10'

    test 'check add deck works', ->
      deckBuilder.addNewDeck()
      expect(deckBuilder.currentDeck.name).to.equal 'Unnamed Deck'

    test 'check deck listing works', (done)->
      deckBuilder.addNewDeck()
      deckBuilder.addNewDeck()
      setTimeout =>
        deckPaperItems = deckBuilder.$.deckMenu.querySelectorAll('paper-item').length
        expect(deckPaperItems - 1).to.equal 2
        done()
      , timeoutTime

    test 'check deck renaming works', (done)->
      deckBuilder.addNewDeck()
      deckBuilder.$.deckNameInput.value = "Named Deck"
      deckBuilder.$.deckNameInput.blur()
      setTimeout =>
        expect(deckBuilder.currentDeck.name).to.equal 'Named Deck'
        done()
      , timeoutTime

    test 'check deck selection works', (done)->
      deckBuilder.addNewDeck()
      firstDeckGUID = deckBuilder.currentDeck.guid
      deckBuilder.addNewDeck()
      deckBuilder.$.deckNameInput.value = "Named Deck"
      deckBuilder.$.deckNameInput.blur()
      setTimeout =>
        element = deckBuilder.$.deckMenu.querySelectorAll('paper-item')[1]
        expect(element.dataset.guid).to.equal firstDeckGUID
        deckBuilder.loadDeck null, null, element
        setTimeout =>
          expect(deckBuilder.currentDeck.name).to.equal 'Unnamed Deck'
          done()
        , timeoutTime
      , timeoutTime
