deckBuilder = document.querySelector 'deck-builder'
img = document.querySelector 'img'
img.style.display = "none"
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
      , 100

    test 'check deck renaming works', (done)->
      deckBuilder.addNewDeck()
      deckBuilder.$.deckNameInput.value = "Named Deck"
      deckBuilder.$.deckNameInput.blur()
      #deckBuilder.$.deckMenu.querySelectorAll('paper-item')[0].click()
      setTimeout =>
        expect(deckBuilder.currentDeck.name).to.equal 'Named Deck'
        done()
      , 100

    test 'check deck selection works', (done)->
      deckBuilder.addNewDeck()
      deckBuilder.addNewDeck()
      deckBuilder.$.deckNameInput.value = "Named Deck"
      deckBuilder.$.deckNameInput.blur()
      setTimeout =>
        element = deckBuilder.$.deckMenu.querySelectorAll('paper-item')[0]
        deckBuilder.loadDeck null, null, element
        setTimeout =>
          expect(deckBuilder.currentDeck.name).to.equal 'Unnamed Deck'
          done()
        , 100
      , 100
