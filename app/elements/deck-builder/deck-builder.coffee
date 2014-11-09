Polymer 'deck-builder',
  dataObject: {}
  saveToForageTimeout: null
  layoutTimeout: null
  deckPacker: {}
  collectionPacker: {}
  created: ->
    @deleteCollection()
    return
  ready: ->
    @decks = [
      {"name": "Deck 1"}
      {"name": "Deck 2"}
      {"name": "Deck 3"}
    ]

    ##BELOW THIS IS REAL CODE!

    @getDataFromForage @loadCollection


    @addEventListener 'new-image', (event)->
      @addCardToCollection event.detail.imageData
      @addCardToWindow @collectionPacker, event.detail.imageData

    return
  getDataFromForage: (callback)->
    localforage.getItem("dataObject").then (dataObject)=>
      @dataObject = dataObject if dataObject != null
      callback.bind(@)()

    return
  saveDataToForage: ->
    clearTimeout @saveToForageTimeout
    @saveToForageTimeout = setTimeout =>
      localforage.setItem("dataObject", @dataObject)
    , 250
    return
  layoutCards: ()->
    clearTimeout @layoutTimeout
    @layoutTimeout = setTimeout =>
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
    @dataObject =
      collection: []
      decks: {}
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
