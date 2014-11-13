Polymer 'deck-builder',
  deckPacker: {}
  collectionPacker: {}
  selectedDeck: ""
  packerOptions: {}
  created: ->
    @packerOptions =
      itemSelector: "builder-card"
      columnWidth: "builder-card"
      rowHeight: "builder-card"
      gutter: 8
  ready: ->
    @loadDeck @$.dataStorage.collection

    @loadDeckList()
    return

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


  loadDeck: (deckName)->
    if deckName == @$.dataStorage.collection
      try
        @clearWindow @collectionPacker
        @collectionPacker.destroy()
      @collectionPacker = new Packery @$.collectionWindow, @packerOptions
    else
      try
        @clearWindow @deckPacker
        @deckPacker.destroy()
      @deckPacker = new Packery @$.collectionWindow, @packerOptions
    @$.dataStorage.loadDeck deckName
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
    baseCard = document.createElement 'builder-card'
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
