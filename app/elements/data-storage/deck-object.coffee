class Deck
  guid: ''
  name: 'Unnamed Deck'
  _lastCardAdded: ''
  _lastCardRemoved: ''
  cards: []
  constructor: (guid = window.generateGUID(), name = 'Unnamed Deck', cards = [])->

    @guid = guid
    @name = name
    @cards = cards
    return

  addCard: (cardData)->
    @cards.push cardData
    @_lastCardAdded = cardData
    return

  deleteCard: (cardData)->
    @cards.splice @cards.indexOf(cardData), 1
    @_lastCardRemoved = cardData
    return
