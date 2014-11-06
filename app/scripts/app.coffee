window.addEventListener "polymer-ready", ->
  # Perform some behaviour
  console.log "Polymer is ready to rock!"

  document.querySelector('#addCardButton').addEventListener "click", ->
    card = document.createElement('playing-card')
    card.innerHTML="<h3>This is a test card!</h3>"
    document.querySelector('body').appendChild(card)
