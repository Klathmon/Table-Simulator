window.addEventListener 'polymer-ready', ->
  # Perform some behaviour
  console.log 'Polymer is ready to rock!'

  document.querySelector('#openDeckBuilder').addEventListener 'click', ->
    deckBuilder = new DeckBuilder()
    document.body.appendChild deckBuilder
    return

  fieldCard = document.querySelector 'field-card'
  #builderCard = document.querySelector 'builder-card'
  img = document.querySelector 'img'
  fieldCard.imageData = img.src
  #builderCard.imageData = img.src

  return

#  document.querySelector('#addCardButton').addEventListener 'click', ->
#    card = document.createElement('playing-card')
#    card.innerHTML='<h3>This is a test card!</h3>'
#    document.querySelector('body').appendChild(card)
