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
  saveToLSDelay: 500
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
    return new Promise (resolve, reject)=>
      decks = []
      localforage.iterate (value, key)=>
        if key.indexOf(@deckPrefix) > -1
          if key.indexOf(@collection) == -1
            decks.push
              GUID: key.substring @deckPrefix.length
              name: value.deckName
        return
      .then =>
        resolve decks
      return
  # loadDeck runs the "card added" event for each card in the given deck
  loadDeck: (deckGUID)->
    return new Promise (resolve, reject)=>
      localforage.getItem(@deckPrefix + deckGUID).then (deck)=>
        if deck == null and deckGUID = @collection
          @addDeck @collection
          @loadDeck @collection
          return
        deckName = deck.deckName
        cardList = deck.cards
        for cardData in cardList
          @asyncFire 'card-added',
            deckGUID: deckGUID
            deckName: deckName
            cardData: cardData
        resolve deckName
      return
  # deleteDeck deletes the deck and all cards within it
  #  Silently fails if the deck name does not exist
  #  fires the "deck deleted" regardless of if the deck exists or not
  deleteDeck: (deckGUID)->
    localforage.removeItem(@deckPrefix + deckGUID).then =>
      @asyncFire 'deck-deleted',
        deckGUID: deckGUID
    return
  # createDeck creates a deck with no cards in it
  #  TODO: Will add an incrementing number if the deckName already exists
  #  Fires the "deck added" event
  addDeck: (deckName)->
    if deckName == @collection
      deckGUID = @collection
      storedDeckName = ''
    else
      deckGUID = @generateGUID()
      storedDeckName = deckName
    deckData =
      deckName: storedDeckName
      cards: []

    localforage.setItem(@deckPrefix + deckGUID, deckData).then =>
      @asyncFire 'deck-added',
        deckGUID: deckGUID
        deckName: storedDeckName
    return
  # renameDeck renames the deck... All contents stay the same (and in the same order)
  #  TODO: Will add an incrementing number if the deckName already exists
  #  Fires the "deck renamed" event ONLY!
  renameDeck: (deckGUID, newDeckName)->
    return if newDeckName == "" or newDeckName == undefined
    @renameDeckQueue = [] if @renameDeckQueue == undefined
    @renameDeckQueue.push([deckGUID, newDeckName])
    @persistDataToStorage()
    return
  # addCardToDeck does what it says. It will fire the "card added" event
  addCardToDeck: (deckGUID, cardData)->
    @addCardQueue[deckGUID] = [] if @addCardQueue[deckGUID] == undefined
    @addCardQueue[deckGUID].push cardData
    @asyncFire 'card-added',
      deckGUID: deckGUID
      cardData: cardData
    @persistDataToStorage()
    return
  # removeCardToDeck does what it says. It will fire the "card removed" event
  removeCardFromDeck: (deckGUID, cardData)=>
    @removeCardQueue[deckGUID] = [] if @removeCardQueue[deckGUID] == undefined
    @removeCardQueue[deckGUID].push cardData
    @asyncFire 'card-removed',
      deckGUID: deckGUID
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
      for deckGUID, cardArray of @addCardQueue
        localforage.getItem(@deckPrefix + deckGUID).then (deck)=>
          for unused in cardArray
            try
              deck.cards.length
            catch
              deck.cards = []
            finally
              deck.cards.push @addCardQueue[deckGUID].shift()
          localforage.setItem(@deckPrefix + deckGUID, deck)
    , @saveToLSDelay
    @job 'processRemoveCardQueue', =>
      for deckGUID, cardArray of @removeCardQueue
        localforage.getItem(@deckPrefix + deckGUID).then (deck)=>
          for unused in cardArray
            deck.cards.splice deck.cards.indexOf(@removeCardQueue[deckGUID].shift()), 1
          localforage.setItem(@deckPrefix + deckGUID, deck)
    , @saveToLSDelay
    @job 'processRenameDeckQueue', =>
      recursiveRenameDeck = =>
        try
          deckNames = @renameDeckQueue.shift()
          localforage.getItem(@deckPrefix + deckNames[0]).then (deck)=>
            deck.deckName = deckNames[1]
            localforage.setItem(@deckPrefix + deckNames[0], deck).then =>
              recursiveRenameDeck()
        catch
          @asyncFire 'deck-renamed'
      recursiveRenameDeck()
    , @saveToLSDelay
    return
  generateGUID: ->
    d = performance.now() * 100000000
    uuid = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g, (c) ->
      r = (d + Math.random() * 16) % 16 | 0
      d = Math.floor(d / 16)
      ((if c is "x" then r else (r & 0x7 | 0x8))).toString 16
    )
    return uuid
