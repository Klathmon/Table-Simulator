class Deck
  dataStorage: null
  guid: ''
  name: 'Unnamed Deck'
  cards: []
  constructor: (dataStorageObject, guid = window.generateGUID(), name = 'Unnamed Deck', cards = [])->

    @dataStorage = dataStorageObject
    @guid = guid
    @name = name
    @cards = cards
    return

  addCard: (cardData)->
    @cards.push cardData
    @dataStorage.saveDeck @
    return

  deleteCard: (cardData)->
    @cards.splice @cards.indexOf(cardData), 1
    @dataStorage.saveDeck @
    return

  setName: (newDeckName)->
    @name = newDeckName
    @dataStorage.saveDeck @
    return
