baseCard = document.querySelector 'base-card'
img = document.querySelector 'img'
baseCard.imageData = img.src
img.style.display = 'none'

suite '<base-card>', ->

  test 'check element exists', ->
    expect(baseCard.imageData).to.equal img.src
    return

  test 'check element has layout', ->
    computedStyle = window.getComputedStyle baseCard
    expect(computedStyle.getPropertyValue 'width').to.be.above '10'
    expect(computedStyle.getPropertyValue 'height').to.be.above '10'
    return

  test 'check z-index gets incremented', ->
    expect(window.curCardZindex).to.be.undefined
    baseCard.setZindex()
    expect(window.curCardZindex).to.equal 2
    baseCard.setZindex()
    expect(window.curCardZindex).to.equal 2
    window.curCardZindex = 3
    baseCard.setZindex()
    expect(window.curCardZindex).to.equal 4
    return

  return
