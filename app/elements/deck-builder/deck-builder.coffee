Polymer 'deck-builder',
  ready: ->
    @updateDeckList()
    return

  currentDeckChanged: ->
    @currentDeckName = @currentDeck.name
    return

  updateDeckList: ->
    @$.dataStorage.listDecks().then (decks)=>
      console.log decks
      @decks = decks
      return
    return

  newImageUploaded: (event)->
    builderCard = document.createElement 'builder-card'
    builderCard.imageData = event.detail.imageData
    @$.deckSorter.appendChild builderCard
    return

  addNewDeck: ->
    @currentDeck = @$.dataStorage.createDeck()
    @$.dataStorage.saveDeck(@currentDeck).then =>
      @updateDeckList()
      return
    return
