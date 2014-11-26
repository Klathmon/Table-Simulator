Polymer 'deck-builder',
  ready: ->
    @updateDeckList()
    return

  updateDeckList: ->
    @$.dataStorage.listDecks().then (decks)=>
      @decks = decks
      return
    return

  currentDeckChanged: ->
    @job 'save-deck', ->
      @$.dataStorage.saveDeck @currentDeck
      return
    return

  updateCurrentDeckFromSorter: (event)->
    @currentDeck.cards = []
    for cardElement in event.detail.elements
      @currentDeck.cards.push cardElement.imageData
    return

  loadDeck: (event, unknown, element)->
    if typeof @currentDeck is 'undefined'
      @actualLoadDeck(element.dataset.guid)
    else
      @$.dataStorage.saveDeck(@currentDeck).then =>
        @actualLoadDeck(element.dataset.guid)
        return
    return

  actualLoadDeck: (guid)->
    @$.deckSorter.innerHTML = ''
    @$.dataStorage.getDeck(guid).then (deck)=>
      @currentDeck = deck
      asyncCounter = 0
      for cardData in @currentDeck.cards
        @async @addCardToCurrentDeck, [cardData], asyncCounter += (1 / 60)
      return
    return

  addCardToCurrentDeck: (cardData)->
    builderCard = document.createElement 'builder-card'
    builderCard.imageData = cardData
    @$.deckSorter.appendChild builderCard
    return
    return

  addNewDeck: ->
    @currentDeck = @$.dataStorage.createDeck()
    @$.dataStorage.saveDeck(@currentDeck).then =>
      @updateDeckList()
      return
    return

  newImageAdded: (event)->
    @addCardToCurrentDeck event.detail.imageData
    return
