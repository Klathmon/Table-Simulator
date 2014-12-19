class Deck
  guid: ''
  name: 'Unnamed Deck'
  cards: []
  constructor: (
    guid = window.generateGUID(),
    name = 'Unnamed Deck',
    cards = []
  )->

    @guid = guid
    @name = name
    @cards = if cards is null then [] else cards
    return

  addCard: (cardData)->
    @cards.push cardData
    return

  deleteCard: (cardData)->
    @cards.splice @cards.indexOf(cardData), 1
    return

  setName: (newDeckName)->
    @name = newDeckName
    return
