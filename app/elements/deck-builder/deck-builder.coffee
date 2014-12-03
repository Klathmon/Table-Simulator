Polymer 'deck-builder',
  ready: ->
    @updateDeckList()
    return


  updateCurrentDeckFromSorter: (event)->
    return if @currentDeck is null or @currentDeck is undefined
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
  cardCheckboxChanged: ->
    checkedElementsLength = @$.deckSorter.querySelectorAll('.checked').length
    if checkedElementsLength > 0
      @updateCardButtons true
    else
      @updateCardButtons false
    return
  onDropdownElementSelected: (event, unknown, element)->
    if event.detail.isSelected
      @$.dialogAffirmButton.removeAttribute "disabled"
    else
      @$.dialogAffirmButton.setAttribute "disabled", true
    return


  updateCardButtons: (enabled = true)->
      elements = [
        @$.deleteCardsButton
        @$.copyCardsButton
      ]
      @updateButtons elements, enabled

  updateButtons: (elements, enabled = true)->
    for element in elements
      if enabled
        element.removeAttribute 'disabled'
      else
        element.setAttribute 'disabled', true
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
    @$.deckSorter.innerHTML = ''
    @currentDeck = @$.dataStorage.createDeck()
    @$.dataStorage.saveDeck(@currentDeck).then =>
      @updateDeckList()
      return
    return
  loadDeck: (event, unknown, element)->
    if typeof @currentDeck is 'undefined' or @currentDeck is null
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
  deleteDeck: (event, unknown, element)->
    @updateCardButtons false
    guid = if element is undefined then @currentDeck.guid else element.dataset.guid
    @$.dataStorage.deleteDeck(guid).then =>
      @updateDeckList()
      if element is undefined or element.dataset.guid is @currentDeck.guid
        @currentDeck = null
        @$.deckSorter.innerHTML = ''
      return
    return

  deleteSelectedCards: ->
    checkedCards = @$.deckSorter.querySelectorAll('.checked')
    for card in checkedCards
      @$.deckSorter.removeChild card
    @updateCardButtons false
    return
  openCopyDialog: ->
    @numberToCopy = 1
    @deckToCopyTo = null
    @$.copyDialog.opened = true
    return
  copySelectedCards: ->
    checkedCards = @$.deckSorter.querySelectorAll('.checked')
    cardsToAdd = []
    for card in checkedCards
      for i in [0...@numberToCopy]
        cardsToAdd.push card.imageData

    if @deckToCopyTo is @currentDeck.guid
      @addCardToCurrentDeck cardsToAdd
    else
      @$.dataStorage.getDeck(@deckToCopyTo).then (deck)=>
        for cardData in cardsToAdd
          deck.cards.push cardData
        @$.dataStorage.saveDeck(deck)

    # Reset everything back to defaults
    for element in @$.deckSorter.querySelectorAll('builder-card.checked')
      element.$.checkbox.setAttribute 'checked', false
    @numberToCopy = 1
    @deckToCopyTo = null
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
