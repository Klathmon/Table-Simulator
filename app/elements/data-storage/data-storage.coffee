#
# Events:
# DeckAdded
# DeckDeleted
# DeckRenamed
# CardAdded
# CardRemoved
Polymer 'data-storage',
  ready: ->
    return
  # loadDeck runs the "card added" event for each card in the given deck
  loadDeck: (deckName)->
    return
  # deleteDeck deletes the deck and all cards within it
  deleteDeck: (deckName)->
    return
  # createDeck creates a deck with no cards in it
  createDeck: (deckName)->
    return
  # renameDeck renames the deck... All contents stay the same (and in the same order)
  renameDeck: (oldDeckName, newDeckName)->
    return
  # addCardToDeck does what it says. It will fire the "card added" event
  addCardToDeck: (deckName, cardData)->
    return
  # removeCardToDeck does what it says. It will fire the "card removed" event
  removeCardFromDeck: (deckName, cardData)->
    return
