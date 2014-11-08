Polymer 'deck-builder',
  collection: []
  saveTimeout: null
  addCardTimeout: null
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

    localforage.getItem("collection").then (collectionData)=>
      @collection = collectionData if collectionData != null
      for cardData in @collection
        @addCardToWindow @$.collectionWindow, cardData
      return

    @addEventListener 'new-image', (event)->
      @addCardToCollection event.detail.imageData
      @addCardToWindow @$.collectionWindow, event.detail.imageData

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
    clearTimeout @addCardTimeout
    @addCardTimeout = setTimeout =>
      @packie.layout()
    ,500
  addCardToCollection: (imageData)->
    @collection.push imageData
    clearTimeout @saveTimeout
    @saveTimeout = setTimeout =>
      localforage.setItem("collection", @collection)
    , 250
    return
  menuItemSelected: ->
    @$.scaffold.closeDrawer()
    @packie.layout()
  splitterMouseUp: ->
    @packie.layout()
