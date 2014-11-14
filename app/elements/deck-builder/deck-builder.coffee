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

#### BOUND EVENTS ####
  loadDeckList: ->
    @$.dataStorage.listDecks().then (decks)=>
      @decks = decks
    return
  newImageUploaded: (event)->
    @$.dataStorage.addCardToDeck @$.dataStorage.collection, event.detail.imageData
    return
  newCardAdded: (event)->
    @$.dataStorage.addCardToDeck @selectedDeck, event.detail.imageData
    return
  cardAddedToDeck: (event)->
    if event.detail.deckName == @$.dataStorage.collection
      @addCardToWindow @collectionPacker, event.detail.cardData
    else
      @addCardToWindow @deckPacker, event.detail.cardData
    return
  menuItemSelected: ->
    @$.scaffold.closeDrawer()
    @layoutCards()
    @loadDeck @selectedDeck
    return
  splitterMouseUp: ->
    @layoutCards()
    return
  addNewDeck: ()->
    @$.dataStorage.addDeck "Click here to change Deck name"
    return
  deckAdded: (event)->
    @decks.push event.detail.deckName
    @selectedDeck = event.detail.deckName
    return
  cardDropped: (event)->
    droppedPlace = @shadowRoot.elementFromPoint event.detail.xPos, event.detail.yPos
    while droppedPlace and droppedPlace != @$.deckWindow
      droppedPlace = droppedPlace.parentNode
    return if droppedPlace == null
    return if droppedPlace == event.detail.parent
    @$.dataStorage.addCardToDeck @selectedDeck, event.detail.element.imageData
    return
  deleteCollection: ->
    @$.dataStorage.deleteCollection()
    return
  deckDeleted: (event)->
    if event.detail.deckName == @$.dataStorage.collection
      @clearWindow @collectionPacker
    else
      @clearWindow @deckPacker
    return
#### END BOUND EVENTS ####

#### CHANGED WATCHERS ####
  selectedDeckChanged: ->
    if @selectedDeck != ''
      @$.splitter.classList.remove 'hideMe'
      @$.deckSplitterWindow.classList.remove 'hideMe'
    else
      @$.splitter.classList.add 'hideMe'
      @$.deckSplitterWindow.classList.add 'hideMe'
    @deckName = @selectedDeck
    return
  deckNameChanged: (oldDeckName, newDeckName)->
    if @deckName != @selectedDeck
      @$.dataStorage.renameDeck oldDeckName, newDeckName
    return
#### END CHANGED WATCHERS ####


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
      @deckPacker = new Packery @$.deckWindow, @packerOptions
    @$.dataStorage.loadDeck deckName
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
      if baseCard.imageData == cardData
        packerObj.remove baseCard
        break
    @layoutCards packerObj
    return
  clearWindow: (packerObj)->
    packerObj.remove packerObj.getItemElements()
    @selectedDeck = '' if packerObj == @deckPacker
    return
  layoutCards: ()->
    @job 'layoutCards', =>
      try
        @collectionPacker.layout()
      try
        @deckPacker.layout()
    ,200
    return
