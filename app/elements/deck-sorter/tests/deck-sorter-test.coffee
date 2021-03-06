suite '<deck-sorter>', ->

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
    imageUploader.importFile img1Element.src, 'image/jpg'
    return


  test 'check element exists', ->
    expect(deckSorter.packery).to.be.instanceof Packery
    return

  test 'check adding card works', (done)->
    eventL = (event)->
      expect(event.detail.elements).to.have.length 1
      deckSorter.removeEventListener 'layout-complete', eventL
      done()
      return
    deckSorter.addEventListener 'layout-complete', eventL
    addCardToDeckSorter img1
    return

  test 'check removing card works(fast)', (done)->
    eventL = (event)->
      deckSorter.removeEventListener 'layout-complete', eventL
      expect(event.detail.elements).to.have.length 0
      done()
      return
    deckSorter.addEventListener 'layout-complete', eventL
    oldCard = document.querySelector 'deck-sorter builder-card'
    oldCard.parentNode.removeChild oldCard
    return

  test.skip 'check removing card works (slow)', (done)->
    eventCounter = 0
    eventL = (event)->
      eventCounter++
      if eventCounter is 1
        oldCard = document.querySelector 'deck-sorter builder-card'
        oldCard.parentNode.removeChild oldCard
        return
      else if eventCounter is 2
        expect(event.detail.elements).to.have.length 1
        deckSorter.removeEventListener 'layout-complete', eventL
        done()
    deckSorter.addEventListener 'layout-complete', eventL
    addCardToDeckSorter img2
    return

  return
