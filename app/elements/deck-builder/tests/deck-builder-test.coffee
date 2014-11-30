deckBuilder = document.querySelector 'deck-builder'
img1 = document.querySelector '#img1'
img2 = document.querySelector '#img2'
timeoutTime = 200
addCardToDeckSorter = (img1Element)->
  deckBuilder.$.imageUploader.importFile img1Element.src, 'image/jpg'

testSetup = (done)->
  deckBuilder.$.dataStorage.purgeEverything().then ->
    done()

window.addEventListener "polymer-ready", ->
  suite '<deck-builder> Smoke', ->
    setup testSetup

    test 'check element has layout', ->
      computedStyle = window.getComputedStyle deckBuilder
      expect(computedStyle.getPropertyValue 'width').to.be.above '10'
      expect(computedStyle.getPropertyValue 'height').to.be.above '10'

  suite '<deck-builder> Decks', ->
    setup testSetup

    test 'check add deck works', ->
      deckBuilder.addNewDeck()
      expect(deckBuilder.currentDeck.name).to.equal 'Unnamed Deck'

    test 'check deck listing works', (done)->
      deckBuilder.addNewDeck()
      setTimeout =>
        deckBuilder.addNewDeck()
        setTimeout =>
          deckPaperItems = deckBuilder.$.deckMenu.querySelectorAll('paper-item')
          expect(deckPaperItems).to.have.length 3
          done()
        , timeoutTime
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
        paperElements = deckBuilder.$.deckMenu.querySelectorAll('paper-item')
        if paperElements[0].dataset.guid is firstDeckGUID
          element = paperElements[0]
        else
          element = paperElements[1]
        expect(element.dataset.guid).to.equal firstDeckGUID
        deckBuilder.loadDeck null, null, element
        setTimeout =>
          expect(deckBuilder.currentDeck.name).to.equal 'Unnamed Deck'
          done()
        , timeoutTime
      , timeoutTime

    test 'check deck deletion works', (done)->
      deckBuilder.addNewDeck()
      setTimeout =>
        deckBuilder.deleteDeck()
        setTimeout =>
          deckPaperItems = deckBuilder.$.deckMenu.querySelectorAll('paper-item')
          expect(deckBuilder.currentDeck).to.be.null
          expect(deckPaperItems).to.have.length 1
          done()
        , timeoutTime
      , timeoutTime

    test 'check deck delete button is disabled until deck selected', (done)->
      expect(deckBuilder.$.deleteDeckButton.hasAttribute 'disabled').to.be.true
      deckBuilder.addNewDeck()
      setTimeout ->
        expect(deckBuilder.$.deleteDeckButton.hasAttribute 'disabled').to.be.false
        done()
      , timeoutTime

  suite '<deck-builder> Cards', ->
    setup (done)->
      deckBuilder.deleteDeck()
      testSetup done

    test 'check card buttons are enabled after first card selected', (done)->
      deckBuilder.addNewDeck()
      addCardToDeckSorter img1
      expect(deckBuilder.$.deleteCardsButton.hasAttribute 'disabled').to.be.true
      #deckBuilder.$.deckSorter.querySelector('builder-card').$.checkbox.setAttribute 'checked', true
      setTimeout ->
        deckBuilder.$.deckSorter.querySelector('builder-card').$.checkbox.setAttribute 'checked', true
        setTimeout ->
          expect(deckBuilder.$.deleteCardsButton.hasAttribute 'disabled').to.be.false
          done()
        , timeoutTime
      , timeoutTime

    test 'check delete card button works', (done)->
      deckBuilder.addNewDeck()
      addCardToDeckSorter img1
      expect(deckBuilder.$.deleteCardsButton.hasAttribute 'disabled').to.be.true
      setTimeout ->
        deckBuilder.$.deckSorter.querySelector('builder-card').$.checkbox.setAttribute 'checked', true
        addCardToDeckSorter img2
        setTimeout ->
          deckBuilder.deleteSelectedCards()
          setTimeout ->
            expect(deckBuilder.$.deleteCardsButton.hasAttribute 'disabled').to.be.false
            expect(deckBuilder.$.deckSorter.querySelectorAll('builder-card')).to.have.length 1
          done()
        , timeoutTime
      , timeoutTime
