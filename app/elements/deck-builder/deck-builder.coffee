Polymer 'deck-builder',
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
      baseCard = document.createElement 'base-card'
      baseCard.imageData = event.detail.imageData
      baseCard.draggie.options.grid = [115, 175]
      @addCardToWindow @$.collectionWindow, baseCard
      setTimeout =>
        @packie.layout()
      ,500

    setTimeout =>
      @packie.layout()
    ,500
  addCardToWindow: (containerWindow, card)->
    @packie.bindDraggabillyEvents card.draggie
#    card.draggie.on 'dragStart', =>
#      card.style.width = parseInt(card.style.width - 10) + "px"
    card.draggie.on 'dragEnd', =>
#      card.style.width = parseInt(card.style.width + 10) + "px"
      setTimeout =>
        @packie.layout()
      , 450
    @$.collectionWindow.appendChild card
    @packie.appended card
  importFileButtonClicked: ->
    @$.fileInput.click()
  fileInputChanged: ->
    @filename = @$.fileInput.$.input.files[0].name
  menuItemSelected: ->
    @$.scaffold.closeDrawer()
