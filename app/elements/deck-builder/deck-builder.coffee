Polymer 'deck-builder',
  addCardInterval: null
  firstCard: true
  created: ->
    @cardDataArray = []
    return
  ready: ->
    @updateDeckList()
    return

  # This adds cards which are added to the deckSorter and adds them to the
  # the current deck so it can be saved
  updateCurrentDeckFromSorter: (event)->
    return if @currentDeck is null or @currentDeck is undefined
    @currentDeck.cards = []
    for cardElement in event.detail.elements
      @currentDeck.cards.push cardElement.imageData
    @currentDeckChanged()
    return
  # Saves the deck after it hasn't been called for 100ms
  currentDeckChanged: ->
    if @currentDeck isnt null
      @job 'save-deck', ->
        @$.dataStorage.saveDeck(@currentDeck)
      , 100
    return
  # Updates the decklist in the sidebar and in the dialog windows
  updateDeckList: ->
    @$.dataStorage.listDecks().then (decks)=>
      @decks = decks
      @asyncFire 'decklist-updated'
      return
    return
  # Called when a checkbox is checked/unchecked in the DeckSorter
  # used to update the buttons to be displayed when there is something checked
  cardCheckboxChanged: ->
    checkedElementsLength = @$.deckSorter.querySelectorAll('.checked').length
    if checkedElementsLength > 0
      @updateCardButtons true
    else
      @updateCardButtons false
    return
  # Called when the user selects something from the modal dropdown
  # enables the "Copy" button
  onDropdownElementSelected: (event, detail, element)->
    if event.detail.isSelected
      @$.dialogAffirmButton.removeAttribute "disabled"
    else
      @$.dialogAffirmButton.setAttribute "disabled", true
    return

  # Enables or disables the buttons which rely on checked cards
  updateCardButtons: (enabled = true)->
      elements = [
        @$.deleteCardsButton
        @$.copyCardsButton
        @$.selectNoneButton
      ]
      for element in elements
        if enabled
          element.removeAttribute 'disabled'
        else
          element.setAttribute 'disabled', true
      return

  # Blurs the deckName input if the enter key is pressed
  deckNameOnInput:  (event, detail, element)->
    element.blur() if event.keyCode == 13
    return
  # Saves the deck name when the deckName input is blured
  deckNameOnBlur: (event, detail, element)->
    @currentDeck.name = element.value
    @$.dataStorage.saveDeck(@currentDeck).then =>
      @asyncFire 'deck-renamed'
      @updateDeckList()
      return
    return

  # Prepares the sorter for a new deck (unhides the lower actions, etc...)
  prepSorterForNewDeck: (hide = false)->
    clearInterval @addCardInterval
    @cardDataArray = []
    @updateCardButtons false
    @$.deckSorter.removeElements @$.deckSorter.querySelectorAll("builder-card")
    if hide is true
      @$.lowerActions.classList.add "hidden"
    else
      @$.lowerActions.classList.remove "hidden"
    return
  # This is just a stub method to convert the event to the real function call
  loadDeck: (event, detail, element)->
    @actualLoadDeck(element.dataset.guid)
    return
  # Creates the new deck and makes it the current one
  addNewDeck: ->
    @prepSorterForNewDeck()
    @currentDeck = @$.dataStorage.createDeck()
    @$.dataStorage.saveDeck(@currentDeck).then =>
      @updateDeckList()
      return
    return
  # Clears out the old deck and loads in the new one
  actualLoadDeck: (guid)->
    @prepSorterForNewDeck()
    @$.dataStorage.getDeck(guid).then (deck)=>
      @currentDeck = deck
      @addCardToCurrentDeck @currentDeck.cards
      @asyncFire 'deck-loaded'
    return
  # Deletes the given deck
  # if it is the current deck, then it clears out the sorter
  deleteDeck: (event, detail, element)->
    guid = if element is undefined then @currentDeck.guid else element.dataset.guid
    @$.dataStorage.deleteDeck(guid).then =>
      @updateDeckList()
      if guid is @currentDeck.guid
        @currentDeck = null
        @prepSorterForNewDeck true
      return
    return

  # Un-checks all selected cards in the current deck
  clearSelectedCards: ->
    for element in @$.deckSorter.querySelectorAll 'builder-card.checked'
      element.$.checkbox.setAttribute 'checked', false
    return
  # Checks all cards in the current deck
  selectAllCards: ->
    for element in @$.deckSorter.querySelectorAll 'builder-card'
      element.$.checkbox.setAttribute 'checked', true
    return
  # Deletes all selected cards from the current deck
  deleteSelectedCards: ->
    checkedCards = @$.deckSorter.querySelectorAll 'builder-card.checked'
    @$.deckSorter.removeElements checkedCards
    @updateCardButtons false
    return
  # Sets up required things for the dialog and opens it
  openCopyDialog: ->
    @numberToCopy = 1
    @deckToCopyTo = null
    @$.copyDialog.opened = true
    return
  # Copies selected cards to the selected deck
  # if they are being copied to the current deck, the are added to the sorter
  copySelectedCards: ->
    checkedCards = @$.deckSorter.querySelectorAll 'builder-card.checked'
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
        return

    # Reset everything back to defaults
    @clearSelectedCards()
    @numberToCopy = 1
    @deckToCopyTo = null
    return
  # Creates a BuiderCard and appends it to the Sorter
  # can accept a single card, or an array of cards
  addCardToCurrentDeck: (cardDataArray)->
    return if cardDataArray is []
    cardDataArray = [cardDataArray] if typeof cardDataArray isnt 'object'
    for cardData in cardDataArray
        builderCard = new BuilderCard()
        builderCard.imageData = cardData
        @$.deckSorter.appendChild builderCard
        if @cardDataArray.length % 20 is 0
          @$.deckSorter.packery.layout()
    return
  # Fired from the image-uploader.
  # adds the given cards to the sorter (in a job)
  newImageAdded: (event)->
    @newCardQueue = [] if @newCardQueue is undefined
    @newCardQueue.push event.detail.imageData
    @job 'add-new-image-queue', ->
      @addCardToCurrentDeck @newCardQueue
      @newCardQueue = []
      return
    , 100
    return
