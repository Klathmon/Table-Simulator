window.addEventListener "polymer-ready", ->
  dataStorage = document.querySelector 'data-storage'
  suite '<data-storage>', ->
    setup (done)->
      dataStorage.purgeEverything().then ->
        done()

    test 'check element exists', ->
      expect(dataStorage.deckPrefix).to.equal("Deck:")

    test 'check deck creation', ->
      deck = dataStorage.createDeck()
      expect(deck.guid).to.not.equal('')

    test 'check deck listing', (done)->
      deck = dataStorage.createDeck()
      dataStorage.saveDeck(deck).then ->
        dataStorage.listDecks().then (decks)->
          expect(decks.length).to.equal(1)
          done()

    test 'check deck removal', (done)->
      deck = dataStorage.createDeck()
      dataStorage.saveDeck(deck).then ->
        dataStorage.deleteDeck(deck).then ->
          dataStorage.listDecks().then (decks)->
            expect(decks.length).to.equal(0)
            done()
