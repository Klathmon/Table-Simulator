#
# Events:
# DeckAdded
# DeckDeleted
# DeckRenamed
# CardAdded
# CardRemoved
Polymer 'data-storage',
  deckPrefix: "Deck:"
  # loadDeck runs the "card added" event for each card in the given deck
  loadDeck: (deckName)->
    localForage.getItem(@deckPrefix + deckName).then (deck)->
      for cardData in deck
        @fireAsync 'CardAdded',
          deckName: deckName
          cardData: cardData
    return
  # deleteDeck deletes the deck and all cards within it
  #  Silently fails if the deck name does not exist
  #  fires the "deck deleted" regardless of if the deck exists or not
  deleteDeck: (deckName)->
    localforage.removeItem(@deckPrefix + deckName).then ->
      @fireAsync 'DeckDeleted',
        deckName: deckName
    return
  # createDeck creates a deck with no cards in it
  #  TODO: Will add an incrementing number if the deckName already exists
  #  Fires the "deck added" event
  addDeck: (deckName)->
    localforage.setItem(@deckPrefix + deckName, []).then ->
      @fireAsync 'DeckAdded',
        deckName: deckName
    return
  # renameDeck renames the deck... All contents stay the same (and in the same order)
  #  TODO: Will add an incrementing number if the deckName already exists
  #  Fires the "deck renamed" event ONLY!
  renameDeck: (oldDeckName, newDeckName)->
    localForage.getItem(@deckPrefix + oldDeckName).then (deck)->
      localForage.setItem(@deckPrefix + newDeckName).then ->
        localForage.removeItem(@deckPrefix + oldDeckName).then ->
          @fireAsync 'DeckRenamed',
            deckName: newDeckName
    return
  # addCardToDeck does what it says. It will fire the "card added" event
  addCardToDeck: (deckName, cardData)->
    localForage.getItem(@deckPrefix + deckName).then (deck)->
      deck.push cardData
      localForage.setItem(@deckPrefix + deckName, deck).then ->
        @fireAsync 'CardAdded',
          deckName: deckName
          cardData: cardData
    return
  # removeCardToDeck does what it says. It will fire the "card removed" event
  removeCardFromDeck: (deckName, cardData)->
    localForage.getItem(@deckPrefix + deckName).then (deck)->
      deck.splice deck.indexOf(cardData), 1
      localForage.setItem(@deckPrefix + deckName, deck).then ->
        @fireAsync 'CardRemoved',
          deckName: deckName
          cardData: cardData
    return
