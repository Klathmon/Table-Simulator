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
      @saveDeck observerArray[observerArray.length - 1].object
      return
    return

  createDeck: ->
    deck = new Deck
    @observeDeck deck
    return deck

  getDeck: (guid)->
    return new Promise (resolve, reject)=>
      localforage.getItem(@deckPrefix + guid).then (deck)=>
        if deck is null
          reject 'Deck not found'
        else
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
      localforage.setItem(@deckPrefix + deck.guid).then (deck)=>
        console.log "Deck Saved!"
        resolve deck
        return
      , (err)=>
        reject err
        return
      return

  
