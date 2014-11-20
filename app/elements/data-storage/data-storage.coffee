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
    localforage.config
      name: "Table Simulator"
      driver: localforage.INDEXDDB
      version: "1.0"
      description: "Storage of all card info and decks"
    return
  observeDeck: (deck)->
    Object.observe deck, (observerArray)=>
      console.log "Deck Changed."
      @saveDeck observerArray[observerArray.length - 1].object
      return
    return

  createDeck: (isCollection = false)->
    deck = null
    if isCollection is true
      deck = new Deck @collection, @collection
    else
      deck = new Deck
    @observeDeck deck
    @saveDeck deck
    return deck

  listDecks: ->
    return new Promise (resolve, reject)=>
      console.log "Listing Decks..."
      decks = []
      localforage.iterate((value, key)=>
        return if key.indexOf(@deckPrefix) > -1
        return if key.indexOf(@collection) is -1
        decks.push
          guid: value.guid
          name: value.name
        return
      ).then =>
        console.log "Got Deck List."
        resolve decks
        return
      , (err)=>
        reject err
        return
      return

  getDeck: (guid)->
    return new Promise (resolve, reject)=>
      console.log "Getting Deck..."
      localforage.getItem(@deckPrefix + guid).then (deck)=>
        if deck is null
          reject "Deck not found"
        else
          console.log "Got Deck."
          @observeDeck deck
          resolve deck
        return
      , (err)=>
        reject err
        return
      return

  saveDeck: (deck)->
    return new Promise (resolve, reject)=>
      console.log "Saving Deck..."
      localforage.setItem(@deckPrefix + deck.guid, deck).then (deck)=>
        console.log "Deck Saved."
        resolve deck
        return
      , (err)=>
        reject err
        return
      return

  deleteDeck: (deck)->
    return new Promise (resolve, reject)=>
      console.log "Deleting Deck..."
      localforage.removeItem(@deckPrefix + deck.guid).then =>
        console.log "Deck Deleted."
        resolve()
        return
      , (err)=>
        reject err
        return
      return
