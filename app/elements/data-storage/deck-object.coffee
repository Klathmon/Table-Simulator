class Deck
  guid: ''
  name: 'Unnamed Deck'
  cards: []
  constructor: (guid = window.generateGUID(), name = 'Unnamed Deck', cards = [])->

    @guid = guid
    @name = name
    @cards = cards

    notifier = Object.getNotifier @
    Array.observe @cards, ->
      notifier.notify
        type: 'update'
        name: 'cards'
        oldValue: null
      return
    return

  addCard: (cardData)->
    @cards.push cardData
    return

  deleteCard: (cardData)->
    @cards.splice @cards.indexOf(cardData), 1
    return
