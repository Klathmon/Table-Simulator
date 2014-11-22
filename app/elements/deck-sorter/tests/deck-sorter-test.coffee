window.addEventListener "polymer-ready", ->
  img1 = document.querySelector '#img1'
  img2 = document.querySelector '#img2'
  imageUploader = document.querySelector 'image-uploader'
  deckSorter = document.querySelector 'deck-sorter'

  addCardToDeckSorter = (img1Element)->
    newImage = (event)->
      card = document.createElement 'builder-card'
      card.imageData = event.detail.imageData
      deckSorter.appendChild card
      imageUploader.removeEventListener 'new-image', newImage
      return
    imageUploader.addEventListener 'new-image', newImage
    imageUploader.importFile img1.src, 'image/jpg'

  suite '<deck-sorter>', ->
    test 'check element exists', ->
      expect(deckSorter.packery).to.be.instanceof Packery

    test 'check adding card works', (done)->
      eventL = (event)->
        expect(event.detail.elements).to.have.length 1
        deckSorter.removeEventListener 'layout-complete', eventL
        done()
      deckSorter.addEventListener 'layout-complete', eventL
      addCardToDeckSorter(img1)

    test 'check removing card works', (done)->
      eventL = (event)->
        expect(event.detail.elements).to.have.length 1
        deckSorter.removeEventListener 'layout-complete', eventL
        done()
      deckSorter.addEventListener 'layout-complete', eventL
      oldCard = document.querySelector 'deck-sorter builder-card'
      oldCard.parentNode.removeChild oldCard
      addCardToDeckSorter(img2)