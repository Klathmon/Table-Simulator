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
  return


suite.skip '<base-card> Benchmarks', ->
  test 'Create 10 BaseCards', (done)->
    for x in [0...10]
      baseCard2 = new BaseCard()
      baseCard2.imageData = img.src
      document.body.appendChild baseCard2
      Polymer.flush()
    done()
    return
  return
