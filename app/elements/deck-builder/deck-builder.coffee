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
  newImageUploaded: (event)->
    @$.dataStorage.addCardToDeck @$.dataStorage.collection, event.detail.imageData
    return
  newCardAdded: (event)->
    @$.dataStorage.addCardToDeck @selectedDeck, event.detail.imageData
    return
  cardAddedToDeck: (event)->
    if event.detail.deckGUID == @$.dataStorage.collection
      @addCardToWindow @collectionPacker, event.detail.cardData
    else
      @addCardToWindow @deckPacker, event.detail.cardData
    return
  loadDeckList: ->
    @$.dataStorage.listDecks().then (decks)=>
      @decks = decks
    return
  menuItemSelected: ->
    @$.scaffold.closeDrawer()
    @layoutCards()
    return
  addNewDeck: ()->
    @$.dataStorage.addDeck "Click here to change Deck name"
    @layoutCards()
    return
  deckAdded: (event)->
    if event.detail.deckGUID != @$.dataStorage.collection
      @decks.push event.detail
      @selectedDeckGUID = event.detail.deckGUID
    return
  cardDropped: (event)->
    droppedPlace = @shadowRoot.elementFromPoint event.detail.xPos, event.detail.yPos
    while droppedPlace and droppedPlace != @$.deckWindow
      droppedPlace = droppedPlace.parentNode
    return if droppedPlace == null
    return if droppedPlace == event.detail.parent
    @$.dataStorage.addCardToDeck @selectedDeckGUID, event.detail.element.imageData
    return
  deleteCollection: ->
    @$.dataStorage.deleteCollection()
    return
  deckDeleted: (event)->
    if event.detail.deckGUID == @$.dataStorage.collection
      @clearWindow @collectionPacker
    else
      @clearWindow @deckPacker
      setTimeout =>
        @selectedDeckGUID = ''
      , 200
    return
  deckNameFieldBlur: ->
    @$.dataStorage.renameDeck @selectedDeckGUID, @deckName
    return
  deckNameOnInput: (event)->
    event.target.blur() if event.keyCode == 13
    return
  startSplitterDrag: ->
    @$.deckSplitterWindow.classList.add 'dragging'
    @draggingSplitterInterval = setInterval =>
      @layoutCards()
    , 500
    return
  endSplitterDrag: ->
    @$.deckSplitterWindow.classList.remove 'dragging'
    clearInterval @draggingSplitterInterval
    @layoutCards()
    return
#### END BOUND EVENTS ####

#### CHANGED WATCHERS ####
  selectedDeckGUIDChanged: ->
    if @selectedDeckGUID == ''
      @$.splitter.classList.add 'hideMe'
      @$.deckSplitterWindow.classList.add 'hideMe'
    else
      @$.splitter.classList.remove 'hideMe'
      @$.deckSplitterWindow.classList.remove 'hideMe'
      @loadDeck @selectedDeckGUID
    return
#### END CHANGED WATCHERS ####

  loadDeck: (deckGUID)->
    if deckGUID == @$.dataStorage.collection
      try
        @clearWindow @collectionPacker
        @collectionPacker.destroy()
      @collectionPacker = new Packery @$.collectionWindow, @packerOptions
      @$.dataStorage.loadDeck @$.dataStorage.collection
    else
      try
        @clearWindow @deckPacker
        @deckPacker.destroy()
      @deckPacker = new Packery @$.deckWindow, @packerOptions
      @$.dataStorage.loadDeck(deckGUID).then (deckName)=>
        @deckName = deckName
        return
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
    return
  layoutCards: ()->
    @job 'layoutCards', =>
      try
        @collectionPacker.layout()
      try
        @deckPacker.layout()
    ,100
    return
