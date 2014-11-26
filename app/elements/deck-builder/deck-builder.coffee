Polymer 'deck-builder',
  ready: ->
    @updateDeckList()
    return

  updateDeckList: ->
    @$.dataStorage.listDecks().then (decks)=>
      @decks = decks
      return
    return

  saveCurrentDeck: (event)->
    @currentDeck.cards = []
    for cardElement in event.detail.elements
      @currentDeck.cards.push cardElement.imageData
    console.log "Saving!"
    return @$.dataStorage.saveDeck @currentDeck

  addNewDeck: ->
    @currentDeck = @$.dataStorage.createDeck()
    @$.dataStorage.saveDeck(@currentDeck).then =>
      @updateDeckList()
      return
    return

  loadDeck: (event, unknown, element)->
    @$.deckSorter.removeAllElements()
    @$.dataStorage.getDeck(element.dataset.guid).then (deck)=>
      @currentDeck = deck
      for cardData in @currentDeck.cards
        @addCardToCurrentDeck cardData
      return
    return

  addCardToCurrentDeck: (cardData)->
    builderCard = document.createElement 'builder-card'
    builderCard.imageData = cardData
    @$.deckSorter.appendChild builderCard
    return

  newImageAdded: (event)->
    @addCardToCurrentDeck event.detail.imageData
    return
