Polymer 'deck-builder-toolbar',
  decks: null # The list of decks from the datastorage
  deckGUID: null # The deck which this toolbar will be working on
  selectedCards: null # An array of cards which are currently selected
  created: ->
    @decks = []
    return
  ready: ->
    @$.dataStorage.listDecks().then (decks)=>
      @decks = decks
      return
    return

  deckGUIDChanged: ->
    return @updateButtons()

  selectedCardsChanged: ->
    return @updateButtons()

  # Update the buttons to be disabled/enabled based on the selectedCards
  updateButtons: ->

    @selectedCards = [] if @selectedCards is null

    return if @deckGUID is null

    if @selectedCards.length is 0
      @$.selectNoneButton.setAttribute 'disabled', true
      @$.copySelectedButton.setAttribute 'disabled', true
      @$.deleteSelectedButton.setAttribute 'disabled', true
    else
      @$.selectNoneButton.removeAttribute 'disabled'
      @$.copySelectedButton.removeAttribute 'disabled'
      @$.deleteSelectedButton.removeAttribute 'disabled'

    # And just to be fancy, disable select all if all cards are selected
    # but do it async, because it can take a long time to get that information
    # and return the promise from here so it's easier to test
    return @$.dataStorage.getDeck(@deckGUID).then (deck)=>
      if @selectedCards.length is deck.cards.length
        @$.selectAllButton.setAttribute 'disabled', true
      else
        @$.selectAllButton.removeAttribute 'disabled'
      return

  clearSelected: ->
    @selectedCards = []
    return @updateButtons()
