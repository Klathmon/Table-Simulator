deckBuilder = document.querySelector 'deck-builder'
img1 = document.querySelector '#img1'
img2 = document.querySelector '#img2'
timeoutTime = 250
addCardToDeckSorter = (imgElement)->
  deckBuilder.$.imageUploader.importFile imgElement.src, 'image/jpg'

testSetup = (done)->
  deckBuilder.$.dataStorage.purgeEverything().then ->
    done()

eventFire = (element, type)->
  if element.fireEvent
    (element.fireEvent('on' + type))
  else
    evObj = document.createEvent('Events')
    evObj.initEvent(type, true, false)
    element.dispatchEvent evObj
  return

window.addEventListener "polymer-ready", ->
  suite '<deck-builder> Smoke', ->
    setup testSetup

    test 'check element has layout', ->
      computedStyle = window.getComputedStyle deckBuilder
      expect(computedStyle.getPropertyValue 'width').to.be.above '10'
      expect(computedStyle.getPropertyValue 'height').to.be.above '10'

  suite '<deck-builder> Decks', ->
    setup testSetup

    test 'check add deck works', (done)->
      deckBuilder.addNewDeck()
      animationFrameFlush ->
        expect(deckBuilder.currentDeck.name).to.equal 'Unnamed Deck'
        done()

    test 'check deck listing works', (done)->
      eventCount = 0
      tempEvent = ->
        eventCount++
        if eventCount is 2
          deckBuilder.removeEventListener 'decklist-updated', tempEvent
          animationFrameFlush ->
            expect(deckBuilder.$.deckMenu.querySelectorAll('paper-item')).to.have.length 3
            done()
      deckBuilder.addEventListener 'decklist-updated', tempEvent
      deckBuilder.addNewDeck()
      deckBuilder.addNewDeck()

    test 'check deck renaming works', (done)->
      eventCount = 0
      tempEvent = ->
        eventCount++
        if eventCount is 1
          deckBuilder.removeEventListener 'decklist-updated', tempEvent
          animationFrameFlush ->
            expect(deckBuilder.currentDeck.name).to.equal 'Named Deck'
            done()
      deckBuilder.addNewDeck()
      deckBuilder.$.deckNameInput.value = "Named Deck"
      deckBuilder.addEventListener 'decklist-updated', tempEvent
      deckBuilder.$.deckNameInput.blur()

    test 'check deck selection works', (done)->
      tempEvent2 = ->
        deckBuilder.removeEventListener 'deck-loaded', tempEvent2
        animationFrameFlush ->
          expect(deckBuilder.currentDeck.name).to.equal 'Unnamed Deck'
          done()
      tempEvent = ->
        deckBuilder.removeEventListener 'decklist-updated', tempEvent
        animationFrameFlush ->
          paperElements = deckBuilder.$.deckMenu.querySelectorAll('paper-item')
          if paperElements[0].dataset.guid is firstDeckGUID
            element = paperElements[0]
          else
            element = paperElements[1]
          expect(element.dataset.guid).to.equal firstDeckGUID
          deckBuilder.addEventListener 'deck-loaded', tempEvent2
          deckBuilder.loadDeck null, null, element

      deckBuilder.addNewDeck()
      firstDeckGUID = deckBuilder.currentDeck.guid
      deckBuilder.addNewDeck()
      deckBuilder.$.deckNameInput.value = "Named Deck"
      deckBuilder.addEventListener 'decklist-updated', tempEvent
      deckBuilder.$.deckNameInput.blur()

    test 'check deck deletion works', (done)->
      eventCount = 0
      eventCount2 = 0
      eventCount3 = 0
      tempEvent3 = ->
        eventCount3++
        if eventCount3 is 5
          deckBuilder.removeEventListener 'layout-complete', tempEvent3
          animationFrameFlush ->
            expect(deckBuilder.$.deckSorter.querySelectorAll 'builder-card').to.have.length 0
            done()
      tempEvent2 = ->
        eventCount2++
        if eventCount2 is 1
          deckBuilder.removeEventListener 'deck-deleted', tempEvent2
          deckBuilder.addEventListener 'layout-complete', tempEvent3
          expect(deckBuilder.currentDeck).to.be.null
          expect(deckBuilder.$.deckMenu.querySelectorAll('paper-item')).to.have.length 1
      tempEvent = ->
        eventCount++
        if eventCount is 3
          deckBuilder.removeEventListener 'deck-saved', tempEvent
          deckBuilder.addEventListener 'deck-deleted', tempEvent2
          expect(deckBuilder.currentDeck).to.not.be.null
          expect(deckBuilder.$.deckMenu.querySelectorAll('paper-item')).to.have.length 2
          deckBuilder.deleteDeck()

      deckBuilder.addEventListener 'deck-saved', tempEvent
      deckBuilder.addNewDeck()
      addCardToDeckSorter img1

  suite '<deck-builder> Cards', ->
    setup testSetup

    teardown (done)->
      deckBuilder.deleteDeck()
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
      eventCount3 = 0
      tempEvent3 = ->
        eventCount3++
        if eventCount3 is 8
          deckBuilder.removeEventListener 'layout-complete', tempEvent3
          animationFrameFlush ->
            expect(deckBuilder.$.deckSorter.querySelectorAll('builder-card')).to.have.length 1
            expect(deckBuilder.$.deleteCardsButton.hasAttribute 'disabled').to.be.true
            done()
      tempEvent2 = ->
        eventCount2++
        if eventCount2 is 1
          deckBuilder.removeEventListener 'checkbox-changed', tempEvent2
          animationFrameFlush ->
            deckBuilder.addEventListener 'layout-complete', tempEvent3
            expect(deckBuilder.$.deleteCardsButton.hasAttribute 'disabled').to.be.false
            deckBuilder.deleteSelectedCards()
      tempEvent = ->
        eventCount++
        if eventCount is 5
          deckBuilder.removeEventListener 'deck-saved', tempEvent
          animationFrameFlush ->
            deckBuilder.addEventListener 'checkbox-changed', tempEvent2
            deckBuilder.$.deckSorter.querySelector('builder-card').$.checkbox.setAttribute 'checked', true
      deckBuilder.addEventListener 'deck-saved', tempEvent
      deckBuilder.addNewDeck()
      addCardToDeckSorter img1
      addCardToDeckSorter img2
      return

    test 'check copy button opens dialog', (done)->
      eventCount = 0
      eventCount2 = 0
      eventCount3 = 0
      eventCount4 = 0
      tempEvent4 = ->
        eventCount4++
        if eventCount4 is 1
          deckBuilder.removeEventListener 'core-overlay-close-completed', tempEvent4
          animationFrameFlush ->
            expect(deckBuilder.$.copyDialog.opened).to.be.false
            done()
      tempEvent3 = ->
        eventCount3++
        if eventCount3 is 1
          deckBuilder.removeEventListener 'core-overlay-open-completed', tempEvent3
          animationFrameFlush ->
            deckBuilder.addEventListener 'core-overlay-close-completed', tempEvent4
            expect(deckBuilder.$.copyDialog.opened).to.be.true
            deckBuilder.$.dialogDismissButton.click()
            done()
      tempEvent2 = ->
        eventCount2++
        if eventCount2 is 1
          deckBuilder.removeEventListener 'checkbox-changed', tempEvent2
          animationFrameFlush ->
            deckBuilder.addEventListener 'core-overlay-open-completed', tempEvent3
            eventFire deckBuilder.$.copyCardsButton, 'tap'
            done()
      tempEvent = ->
        eventCount++
        if eventCount is 5
          deckBuilder.removeEventListener 'deck-saved', tempEvent
          animationFrameFlush ->
            deckBuilder.addEventListener 'checkbox-changed', tempEvent2
            deckBuilder.$.deckSorter.querySelector('builder-card').$.checkbox.setAttribute 'checked', true
      deckBuilder.addEventListener 'deck-saved', tempEvent
      deckBuilder.addNewDeck()
      addCardToDeckSorter img1
      addCardToDeckSorter img2
      return

    test.skip 'check copying 2 copies of a card to another deck works', (done)->
      deckBuilder.addNewDeck()
      deck1guid = deckBuilder.currentDeck.guid
      deckBuilder.addNewDeck()
      addCardToDeckSorter img1
      addCardToDeckSorter img2
      setTimeout ->
        deckBuilder.$.deckSorter.querySelectorAll('builder-card')[0].$.checkbox.setAttribute 'checked', true
        setTimeout ->
          deckBuilder.numberToCopy = 2
          deckBuilder.deckToCopyTo = deck1guid
          deckBuilder.copySelectedCards()
          setTimeout ->
            expect(deckBuilder.$.deckSorter.querySelectorAll('builder-card.checked')).to.have.length 0
            expect(deckBuilder.$.copyCardsButton.hasAttribute 'disabled').to.be.true
            deckBuilder.$.dataStorage.getDeck(deck1guid).then (deck)->
              expect(deck.cards).to.have.length 2
              done()
          , timeoutTime
        , timeoutTime
      , (timeoutTime * 2)

    test.skip 'check copying 2 copies of a card to the current deck works', (done)->
      deckBuilder.addNewDeck()
      addCardToDeckSorter img1
      addCardToDeckSorter img2
      setTimeout ->
        deckBuilder.$.deckSorter.querySelectorAll('builder-card')[0].$.checkbox.setAttribute 'checked', true
        setTimeout ->
          deckBuilder.numberToCopy = 2
          deckBuilder.deckToCopyTo = deckBuilder.currentDeck.guid
          deckBuilder.copySelectedCards()
          setTimeout ->
            expect(deckBuilder.$.deckSorter.querySelectorAll('builder-card.checked')).to.have.length 0
            expect(deckBuilder.$.copyCardsButton.hasAttribute 'disabled').to.be.true
            expect(deckBuilder.$.deckSorter.querySelectorAll('builder-card')).to.have.length 4
            done()
          , timeoutTime
        , timeoutTime
      , (timeoutTime * 2)
