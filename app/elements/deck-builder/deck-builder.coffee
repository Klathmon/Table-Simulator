Polymer 'deck-builder',
  ready: ->
    @categories = [
      {
        name: "Category 1"
        decks: [
          {
            guid: "1234"
            name: "Deck 1"
          }
          {
            guid: "12345"
            name: "Deck 2"
          }
        ]
      }
      {
        name: "Category 2"
        decks: [
          {
            guid: "1234"
            name: "Deck 1"
          }
          {
            guid: "12345"
            name: "Deck 2"
          }
        ]
      }
    ]
    return
  newImageUploaded: (event)->
    builderCard = document.createElement 'builder-card'
    builderCard.imageData = event.detail.imageData
    @$.deckSorter.appendChild builderCard
    return
