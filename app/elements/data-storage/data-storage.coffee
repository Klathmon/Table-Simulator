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
  ready: ->
    storageName = ''
    if @teststoragename is ''
      storageName = "Table Simulator"
    else
      storageName = @teststoragename

    localforage.config
      name: storageName
      driver: localforage.INDEXDDB
      version: "1.0"
      description: "Storage of all card info and decks"
    return

  createDeck: (isCollection = false)->
    deck = null
    if isCollection is true
      deck = new Deck @, @collection, @collection
    else
      deck = new Deck @,
    @saveDeck deck
    return deck

  listDecks: ->
    return new Promise (resolve, reject)=>
      decks = []
      localforage.iterate((value, key)=>
        return if key.indexOf(@deckPrefix) is not 0
        return if key.indexOf(@collection) is not -1
        decks.push
          guid: value.guid
          name: value.name
        return
      ).then =>
        resolve decks
        return
      , (err)=>
        reject err
        return
      return

  getDeck: (guid)->
    return new Promise (resolve, reject)=>
      localforage.getItem(@deckPrefix + guid).then (deck)=>
        if deck is null
          reject "Deck not found"
        else
          deck = new Deck @, deck.guid, deck.name, deck.cards
          resolve deck
        return
      , (err)=>
        reject err
        return
      return

  saveDeck: (deck)->
    storageDeck =
      guid: deck.guid
      name: deck.name
      cards: deck.cards
    return new Promise (resolve, reject)=>
      localforage.setItem(@deckPrefix + deck.guid, storageDeck).then =>
        resolve deck
        return
      , (err)=>
        reject err
        return
      return

  deleteDeck: (deck)->
    deckGUID = if typeof deck is 'string' then deck else deck.guid
    return new Promise (resolve, reject)=>
      localforage.removeItem(@deckPrefix + deckGUID, resolve)
      return

  purgeEverything: ()->
    return new Promise (resolve, reject)->
      localforage.clear(resolve)
      return
