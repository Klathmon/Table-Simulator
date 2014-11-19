class Deck
  guid: ''
  name: 'Unnamed Deck'
  cards: []
  constructor: (guid, name, cards)->
    if typeof guid == 'undefined'
      @guid = window.generateGUID()
    else
      @guid = guid

    if typeof name == 'undefined'
      @name = 'Unnamed Deck'
    else
      @name = name

    if typeof cards == 'undefined'
      @cards = []
    else
      @cards = cards

    return

  addCard: (cardData)->
    @cards.push cardData
    return

  deleteCard: (cardData)->
    @cards.splice @cards.indexOf(cardData), 1
    return
