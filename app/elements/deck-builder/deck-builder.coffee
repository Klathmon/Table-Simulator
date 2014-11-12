Polymer 'deck-builder',
  deckPacker: {}
  collectionPacker: {}
  packerOptions: {}
  created: ->
    @packerOptions =
      itemSelector: "base-card"
      columnWidth: "base-card"
      rowHeight: "base-card"
      gutter: 10
  ready: ->
    @collectionPacker = new Packery @$.collectionWindow, @packerOptions

    @$.dataStorage.listDecks().then (decks)=>
      @decks = decks

    @$.dataStorage.loadDeck @$.dataStorage.collection
    return
  newImageUploaded: (event)->
    # TODO: BUG: Currently this has a "race condition" if i try to add more than one card at a time
    @$.dataStorage.addCardToDeck @$.dataStorage.collection, event.detail.imageData
    return
  cardAddedToDeck: (event)->
    if event.detail.deckName == @$.dataStorage.collection
      @addCardToWindow @collectionPacker, event.detail.cardData
    return
  layoutCards: ()->
    @job 'layoutCards', =>
      try
        @collectionPacker.layout()
      try
        @deckPacker.layout()
    ,500
    return
  addCardToDeck: (deckName, cardData)->
    @dataObject.decks["deckName"].push cardData
    @saveDataToForage()
    return
  removeCardFromDeck: (deckName, cardData)->
    deckArray = @dataObject.decks[deckName]
    for index, value in deckArray
      deckArray.splice(index, 1) if value == cardData
      break
    @saveDataToForage()
    return
  loadDeck: (deckName)->
    try
      @clearWindow @deckPacker
      @deckPacker.destroy()
    @deckPacker = new Packery @$.deckWindow, @packerOptions
    for cardInfo in @dataObject.decks[deckName]
      @addCardToWindow @deckPacker, cardInfo
    return
  deleteDeck: (deckName)->
    delete @dataObject[deckName]
    @saveDataToForage()
    return
  addCardToCollection: (cardData)->
    @dataObject.collection.push cardData
    @saveDataToForage()
    return
  removeCardFromCollection: (cardData)->
    for index, value in @dataObject.collection
      @dataObject.collection.splice(index, 1) if value == cardData
      for key, value of @dataObject.decks
        @removeCardFromDeck key, cardData
      break
    @saveDataToForage()
    return
  loadCollection: ->
    try
      @clearWindow @collectionPacker
      @collectionPacker.destroy()
    @collectionPacker = new Packery @$.collectionWindow,
      itemSelector: "base-card"
      columnWidth: "base-card"
      rowHeight: "base-card"
      gutter: 10
    for cardInfo in @dataObject.collection
      @addCardToWindow @collectionPacker, cardInfo
    return
  deleteCollection: ->
    @$.dataStorage.deleteCollection()
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
