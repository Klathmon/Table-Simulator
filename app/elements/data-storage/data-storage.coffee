Polymer 'data-storage',
  deckPrefix: 'Deck:'
  created: ->
    isSafari = typeof openDatabase isnt 'undefined' and
      /Safari/.test(navigator.userAgent) and
      not /Chrome/.test(navigator.userAgent)

    localforage.config
      name: 'Table Simulator'
      driver: if isSafari then localforage.WEBSQL else localforage.INDEXDDB
      version: '1.0'
      description: 'Storage of all card info and decks'
    return

  createDeck: ->
    return new Deck()

  listDecks: ->
    return new Promise (resolve, reject)=>
      decks = []
      localforage.iterate((value, key)=>
        return if key.indexOf(@deckPrefix) is not 0
        decks.push
          guid: value.guid
          name: value.name
        return
      ).then ->
        resolve decks
        return
      , (err)->
        reject err
        return
      return

  getDeck: (guid)->
    return new Promise (resolve, reject)=>
      localforage.getItem(@deckPrefix + guid).then (deck)->
        if deck is null
          reject 'Deck not found'
        else
          deck = new Deck deck.guid, deck.name, deck.cards
          resolve deck
        return
      , (err)->
        reject err
        return
      return

  saveDeck: (deck)->
    storageDeck =
      guid: deck.guid
      name: deck.name
      cards: if deck.cards is [] then null else deck.cards
    return new Promise (resolve, reject)=>
      localforage.setItem(@deckPrefix + deck.guid, storageDeck).then =>
        setTimeout =>
          @asyncFire 'deck-saved',
            guid: deck.guid
          resolve deck
          return
        ,1
        return
      , (err)->
        reject err
        return
      return

  deleteDeck: (deck)->
    deckGUID = if typeof deck is 'string' then deck else deck.guid
    return new Promise (resolve, reject)=>
      localforage.removeItem(@deckPrefix + deckGUID, resolve).then =>
        @asyncFire 'deck-deleted',
          guid: deckGUID
        return
      return

  purgeEverything: ()->
    return new Promise (resolve, reject)->
      localforage.clear(resolve)
      return
