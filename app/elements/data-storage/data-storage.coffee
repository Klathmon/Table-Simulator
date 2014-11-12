#
# Events:
# deck-added
# deck-deleted
# deck-renamed
# card-added
# card-removed
Polymer 'data-storage',
  deckPrefix: "Deck:"
  collection: "__COLLECTION"
  addCardQueue: {}
  removeCardQueue: {}
  renameDeckQueue: []
  ready: ->
    localforage.config
      name: "Table Simulator"
      driver: localforage.INDEXDDB
      version: "1.0"
      description: "Storage of all card info and decks"
    return
  # listDecks returns an array of deck names (not including the collection)
  #  returns an ES6 promise
  listDecks: ()->
    localforage
    return new Promise (resolve, reject)=>
      localforage.keys().then (keys)=>
        decks = []
        for keyName in keys
          if keyName.indexOf(@deckPrefix) > -1
            if keyName.indexOf(@collection) == -1
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
    console.log oldDeckName + "     " + newDeckName
    return if oldDeckName == "" or newDeckName == ""
    return if oldDeckName == undefined or newDeckName == undefined
    @renameDeckQueue = [] if @renameDeckQueue == undefined
    @renameDeckQueue.push([oldDeckName, newDeckName])
    @persistDataToStorage()
    return
  # addCardToDeck does what it says. It will fire the "card added" event
  addCardToDeck: (deckName, cardData)->
    @addCardQueue[deckName] = [] if @addCardQueue[deckName] == undefined
    @addCardQueue[deckName].push cardData
    @asyncFire 'card-added',
      deckName: deckName
      cardData: cardData
    @persistDataToStorage()
    return
  # removeCardToDeck does what it says. It will fire the "card removed" event
  removeCardFromDeck: (deckName, cardData)=>
    @removeCardQueue[deckName] = [] if @removeCardQueue[deckName] == undefined
    @removeCardQueue[deckName].push cardData
    @asyncFire 'card-removed',
      deckName: deckName
      cardData: cardData
    @persistDataToStorage()
    return
  # deleteCollection removes ALL decks from the system
  deleteCollection: ->
    localforage.keys().then (keys)=>
      decks = []
      for keyName in keys
        if keyName.indexOf @deckPrefix > -1
          @deleteDeck keyName.substring @deckPrefix.length
    return

  persistDataToStorage: ->
    @job 'processAddCardQueue', =>
      for deckName, cardArray of @addCardQueue
        localforage.getItem(@deckPrefix + deckName).then (deck)=>
          for unused in cardArray
            try
              deck.length
            catch
              deck = []
            finally
              deck.push @addCardQueue[deckName].shift()
          localforage.setItem(@deckPrefix + deckName, deck)
    , 500
    @job 'processRemoveCardQueue', =>
      for deckName, cardArray of @removeCardQueue
        localforage.getItem(@deckPrefix + deckName).then (deck)=>
          for unused in cardArray
            deck.splice deck.indexOf(@removeCardQueue[deckName].shift()), 1
          localforage.setItem(@deckPrefix + deckName, deck)
    , 500
    @job 'processRenameDeckQueue', =>
      recursiveRenameDeck = =>
        try
          deckNames = @renameDeckQueue.shift()
          localforage.getItem(@deckPrefix + deckNames[0]).then (deck)=>
            localforage.setItem(@deckPrefix + deckNames[1], deck).then =>
              localforage.removeItem(@deckPrefix + deckNames[0]).then =>
                recursiveRenameDeck()
        catch
          @asyncFire 'deck-renamed'
      recursiveRenameDeck()
    , 500
    return
