Polymer 'deck-builder',
  ready: ->
    @updateDeckList()
    return


  updateCurrentDeckFromSorter: (event)->
    return if @currentDeck is null
    @currentDeck.cards = []
    for cardElement in event.detail.elements
      @currentDeck.cards.push cardElement.imageData
    @currentDeckChanged()
    return
  currentDeckChanged: ->
    if @currentDeck isnt null
      @job 'save-deck', ->
        @$.dataStorage.saveDeck @currentDeck
        return
      , 100
    return
  updateDeckList: ->
    @$.dataStorage.listDecks().then (decks)=>
      @decks = decks
      return
    return


  deckNameOnInput:  (event, unknown, element)->
    element.blur() if event.keyCode == 13
    return
  deckNameOnBlur: (event, unknown, element)->
    @currentDeck.name = element.value
    @$.dataStorage.saveDeck(@currentDeck).then =>
      @updateDeckList()
      return
    return


  addNewDeck: ->
    @currentDeck = @$.dataStorage.createDeck()
    @$.dataStorage.saveDeck(@currentDeck).then =>
      @updateDeckList()
      return
    return
  loadDeck: (event, unknown, element)->
    if typeof @currentDeck is 'undefined'
      @actualLoadDeck(element.dataset.guid)
    else
      @$.dataStorage.saveDeck(@currentDeck).then =>
        @actualLoadDeck(element.dataset.guid)
        return
    return
  actualLoadDeck: (guid)->
    @$.deckSorter.innerHTML = ''
    @$.dataStorage.getDeck(guid).then (deck)=>
      @currentDeck = deck
      @addCardToCurrentDeck @currentDeck.cards
    return
  deleteDeck: ->
    @$.dataStorage.deleteDeck(@currentDeck).then =>
      @currentDeck = null
      @$.deckSorter.innerHTML = ''
      @updateDeckList()
      return
    return

  addCardToCurrentDeck: (cardDataArray)->
    return if cardDataArray is []
    cardDataArray = [cardDataArray] if typeof cardDataArray isnt 'object'
    fragment = document.createDocumentFragment()
    for cardData in cardDataArray
      builderCard = new BuilderCard()
      builderCard.imageData = cardData
      fragment.appendChild builderCard
    @$.deckSorter.appendChild fragment
    return
  newImageAdded: (event)->
    @newCardQueue = [] if @newCardQueue is undefined
    @newCardQueue.push event.detail.imageData
    @job 'add-new-image-queue', ->
      @addCardToCurrentDeck @newCardQueue
      @newCardQueue = []
      return
    , 100
    return
