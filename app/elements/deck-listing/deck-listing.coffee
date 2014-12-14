Polymer 'deck-listing',
  decks: null # The list of decks which this element will maintain
  created: ->
    @decks = []
    return
  ready: ->
    @updateDeckList()
    return

  # Updates the decklist in the sidebar
  updateDeckList: ->
    @$.dataStorage.listDecks().then (decks)=>
      @decks = decks
      @asyncFire 'decklist-updated'
      return
    return

  addNewDeck: ->
    deck = @$.dataStorage.createDeck()
    @$.dataStorage.saveDeck(deck).then =>
      @updateDeckList()
      @asyncFire 'deck-created', deck
      return
    return

  selectDeck: (event, detail, element)->
    @$.dataStorage.getDeck(element.dataset.guid).then (deck)=>
      @fire 'deck-selected', deck
    return

  deleteDeck: (event, detail, element)->
    console.log 'Deleting deck...'
    @$.dataStorage.deleteDeck(element.dataset.guid).then =>
      @updateDeckList()
      return
    return