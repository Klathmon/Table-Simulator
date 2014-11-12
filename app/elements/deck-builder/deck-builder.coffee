Polymer 'deck-builder',
  deckPacker: {}
  collectionPacker: {}
  selectedDeck: ""
  packerOptions: {}
  created: ->
    @packerOptions =
      itemSelector: "base-card"
      columnWidth: "base-card"
      rowHeight: "base-card"
      gutter: 10
  ready: ->
    @collectionPacker = new Packery @$.collectionWindow, @packerOptions

    @loadDeckList()

    @$.dataStorage.loadDeck @$.dataStorage.collection
    return

#######EVENTS#######
  loadDeckList: ->
    @$.dataStorage.listDecks().then (decks)=>
      @decks = decks
    return
  newImageUploaded: (event)->
    @$.dataStorage.addCardToDeck @$.dataStorage.collection, event.detail.imageData
    return
  cardAddedToDeck: (event)->
    if event.detail.deckName == @$.dataStorage.collection
      @addCardToWindow @collectionPacker, event.detail.cardData
    return
  deckAdded: (event)->
    @decks.push event.detail.deckName
    return
#####END-EVENTS#####

  addNewDeck: ()->
    @$.dataStorage.addDeck "Click here to change Deck name"
    return
  selectedDeckChanged: ->
    @deckName = @selectedDeck
    return
  deckNameChanged: (oldDeckName, newDeckName)->
    if @deckName != @selectedDeck
      @$.dataStorage.renameDeck oldDeckName, newDeckName
    return

  layoutCards: ()->
    @job 'layoutCards', =>
      try
        @collectionPacker.layout()
      try
        @deckPacker.layout()
    ,500
    return
  addCardToWindow: (packerObj, cardData)->
    baseCard = document.createElement 'base-card'
    baseCard.imageData = cardData
    packerObj.bindDraggabillyEvents baseCard.draggie
    packerObj.element.appendChild baseCard
    packerObj.appended baseCard
    @layoutCards packerObj
    return
  removeCardFromWindow: (packerObj, cardData)->
    for baseCard in packerObj.getItemElements()
      if baseCard.imageData = cardData
        packerObj.remove baseCard
        break
    @layoutCards packerObj
    return
  clearWindow: (packerObj)->
    packerObj.remove packerObj.getItemElements()
    return

  menuItemSelected: ->
    @$.scaffold.closeDrawer()
    @layoutCards()
    return
  splitterMouseUp: ->
    @layoutCards()
    return
