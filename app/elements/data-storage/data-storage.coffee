#
# Events:
# deck-added
# deck-deleted
# deck-renamed
# card-added
# card-removed
Polymer 'data-storage',
  deckPrefix: "Deck:"
  collectionDeckName: "__COLLECTION"
  # listDecks returns an array of deck names (not including the collection)
  #  returns an ES6 promise
  listDecks: ()->
    return new Promise (resolve, reject)=>
      localforage.keys().then (keys)=>
        decks = []
        for keyName in keys
          if keyName.indexOf @deckPrefix > -1
            decks.push keyName.substring @deckPrefix.length
        resolve decks
  # loadDeck runs the "card added" event for each card in the given deck
  loadDeck: (deckName)->
    localforage.getItem(@deckPrefix + deckName).then (deck)=>
      for cardData in deck
        @asyncFire 'card-added',
          deckName: deckName
          cardData: cardData
    return
  # deleteDeck deletes the deck and all cards within it
  #  Silently fails if the deck name does not exist
  #  fires the "deck deleted" regardless of if the deck exists or not
  deleteDeck: (deckName)->
    localforage.removeItem(@deckPrefix + deckName).then =>
      @asyncFire 'deck-deleted',
        deckName: deckName
    return
  # createDeck creates a deck with no cards in it
  #  TODO: Will add an incrementing number if the deckName already exists
  #  Fires the "deck added" event
  addDeck: (deckName)->
    localforage.setItem(@deckPrefix + deckName, []).then =>
      @asyncFire 'deck-added',
        deckName: deckName
    return
  # renameDeck renames the deck... All contents stay the same (and in the same order)
  #  TODO: Will add an incrementing number if the deckName already exists
  #  Fires the "deck renamed" event ONLY!
  renameDeck: (oldDeckName, newDeckName)->
    localforage.getItem(@deckPrefix + oldDeckName).then (deck)=>
      localforage.setItem(@deckPrefix + newDeckName).then =>
        localforage.removeItem(@deckPrefix + oldDeckName).then =>
          @asyncFire 'deck-renamed',
            deckName: newDeckName
            newDeckName: newDeckName
            oldDeckName: oldDeckName
    return
  # addCardToDeck does what it says. It will fire the "card added" event
  addCardToDeck: (deckName, cardData)->
    localforage.getItem(@deckPrefix + deckName).then (deck)=>
      try
        deck.length
      catch
        deck = []
      finally
        deck.push cardData
      localforage.setItem(@deckPrefix + deckName, deck).then =>
        @asyncFire 'card-added',
          deckName: deckName
          cardData: cardData
    return
  # removeCardToDeck does what it says. It will fire the "card removed" event
  removeCardFromDeck: (deckName, cardData)=>
    localforage.getItem(@deckPrefix + deckName).then (deck)=>
      deck.splice deck.indexOf(cardData), 1
      localforage.setItem(@deckPrefix + deckName, deck).then =>
        @asyncFire 'card-removed',
          deckName: deckName
          cardData: cardData
    return
  # deleteCollection removes ALL decks from the system
  deleteCollection: ->
    localforage.keys().then (keys)=>
      decks = []
      for keyName in keys
        if keyName.indexOf @deckPrefix > -1
          localforage.removeItem keyName
    return
