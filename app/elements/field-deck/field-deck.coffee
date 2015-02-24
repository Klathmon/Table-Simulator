Polymer 'field-deck', Platform.mixin(
  created: ->
    @deck = new Deck()
    return
  ready: ->
    @draggie = new Draggabilly @
    return
  deckChanged: ->
    @currentCardCount = @deck.cards.length
    return
  spawnCard: ->
    fieldCard = new FieldCard()
    fieldCard.imageData = @deck.cards.pop()
    @.parentNode.insertBefore fieldCard, @.nextSibling
    return
, window.zoomCard)
