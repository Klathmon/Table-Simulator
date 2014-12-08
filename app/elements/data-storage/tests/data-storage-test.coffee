dataStorage = document.querySelector 'data-storage'
suite '<data-storage>', ->
  setup (done)->
    dataStorage.purgeEverything().then ->
      done()

  test 'check element exists', ->
    expect(dataStorage.deckPrefix).to.equal "Deck:"

  test 'check deck creation', (done)->
    deck = dataStorage.createDeck()
    expect(deck.guid).to.not.equal ''
    done()

  test 'check deck saving', (done)->
    deck = dataStorage.createDeck()
    dataStorage.saveDeck(deck).then ->
      deck.addCard 'pretendThisIsCardData'
      deck.addCard 'pretendThisIsCardData2'
      dataStorage.saveDeck(deck).then ->
        dataStorage.getDeck(deck.guid).then (newDeck)->
          expect(newDeck.cards).to.have.length 2
          done()

  test 'check deck listing', (done)->
    deck = dataStorage.createDeck()
    deck.name = "Stupid Deck Name"
    dataStorage.saveDeck(deck).then ->
      dataStorage.listDecks().then (decks)->
        expect(decks).to.have.length 1
        done()

  test 'check deck removal', (done)->
    deck = dataStorage.createDeck()
    dataStorage.saveDeck(deck).then ->
      dataStorage.deleteDeck(deck).then ->
        dataStorage.listDecks().then (decks)->
          expect(decks.length).to.equal 0
          done()
