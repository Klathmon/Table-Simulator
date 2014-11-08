Polymer 'deck-builder',
  collection: {}
  saveToLSTimeout: null
  ready: ->
    @decks = [
      {"name": "Deck 1"}
      {"name": "Deck 2"}
      {"name": "Deck 3"}
    ]

    ##BELOW THIS IS REAL CODE!

    @packie = new Packery(@$.collectionWindow,
      itemSelector: "base-card"
      gutter: 10
    )

    @addEventListener 'new-image', (event)->
      @addCardToCollection event.detail.imageData
      @addCardToWindow @$.collectionWindow, event.detail.imageData
  LSLoaded: ->
    for uuid, cardData of @collection
      @addCardToWindow @$.collectionWindow, cardData
    return

  addCardToWindow: (containerWindow, imageData)->
    baseCard = document.createElement 'base-card'
    baseCard.imageData = imageData
    baseCard.draggie.options.grid = [112, 172]
    @packie.bindDraggabillyEvents baseCard.draggie
    baseCard.draggie.on 'dragEnd', =>
      setTimeout =>
        @packie.layout()
      , 450
    @$.collectionWindow.appendChild baseCard
    @packie.appended baseCard
    setTimeout =>
      @packie.layout()
    ,500
  addCardToCollection: (imageData)->
    @collection[generateUUID()] = imageData
    clearTimeout @saveToLSTimeout
    @saveToLSTimeout = setTimeout =>
      @$.collectionLS.save()
    , 1000
    return
  menuItemSelected: ->
    @$.scaffold.closeDrawer()
    @packie.layout()
  splitterMouseUp: ->
    @packie.layout()
