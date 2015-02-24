window.addEventListener 'polymer-ready', ->
  # Perform some behaviour
  console.log 'Polymer is ready to rock!'

  document.querySelector('#openDeckBuilder').addEventListener 'click', ->
    deckBuilder = new DeckBuilder()
    document.body.appendChild deckBuilder
    return

  img = document.querySelector 'img'
  fieldDeck = document.querySelector 'field-deck'
  dataStorage = document.querySelector 'data-storage'
  dataStorage.listDecks().then (decks)->
    deckGUID = decks[0]['guid']
    dataStorage.getDeck(deckGUID).then (deck) ->
      console.log deck
      fieldDeck.deck = deck
      return
    , (err)->
      console.log err
      return
    return
  #fieldCard = document.querySelector 'field-card'
  #builderCard = document.querySelector 'builder-card'
  #fieldCard.imageData = img.src
  #builderCard.imageData = img.src

  return

#  document.querySelector('#addCardButton').addEventListener 'click', ->
#    card = document.createElement('playing-card')
#    card.innerHTML='<h3>This is a test card!</h3>'
#    document.querySelector('body').appendChild(card)
