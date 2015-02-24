suite '<field-card>', ->
  fieldCard = document.querySelector 'field-card'
  img = document.querySelector 'img'
  fieldCard.imageData = img.src



  test 'check element exists', ->
    expect(fieldCard.imageData).to.equal img.src
    return

  test 'check element has layout', ->
    computedStyle = window.getComputedStyle fieldCard
    expect(computedStyle.getPropertyValue 'width').to.be.above '10'
    expect(computedStyle.getPropertyValue 'height').to.be.above '10'
    return

  return
