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
  createDeck: ->
    deck = new Deck
    Object.observe deck, (stuff)->
      console.log stuff

    return deck
