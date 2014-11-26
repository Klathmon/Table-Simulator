Polymer 'deck-builder',
  ready: ->
    @updateDeckList()
    return


  updateCurrentDeckFromSorter: (event)->
    @currentDeck.cards = []
    for cardElement in event.detail.elements
      @currentDeck.cards.push cardElement.imageData
    return
  currentDeckChanged: ->
    if @currentDeck isnt null
      @job 'save-deck', ->
        @$.dataStorage.saveDeck @currentDeck
        return
    return
  updateDeckList: ->
    @$.dataStorage.listDecks().then (decks)=>
      @decks = decks
      return
    return


  deckNameOnInput:  (event, unknown, element)->
    element.blur() if event.keyCode == 13
    return
  deckNameOnBlur: (event, unknown, element)->
    @currentDeck.name = element.value
    @$.dataStorage.saveDeck(@currentDeck).then =>
      @updateDeckList()
      return
    return


  addNewDeck: ->
    @currentDeck = @$.dataStorage.createDeck()
    @$.dataStorage.saveDeck(@currentDeck).then =>
      @updateDeckList()
      return
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
      for cardData in @currentDeck.cards
        @addCardToCurrentDeck cardData
      return
    return
  deleteDeck: ->
    @$.dataStorage.deleteDeck(@currentDeck).then =>
      @currentDeck = null
      @updateDeckList()
      return
    return

  addCardToCurrentDeck: (cardData)->
    setTimeout =>
      builderCard = document.createElement 'builder-card'
      builderCard.imageData = cardData
      @$.deckSorter.appendChild builderCard
      return
    , 1
    return
  newImageAdded: (event)->
    @addCardToCurrentDeck event.detail.imageData
    return
