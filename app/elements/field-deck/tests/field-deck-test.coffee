suite '<field-deck>', ->
  fieldDeck = document.querySelector 'field-deck'

  test 'check element has layout', ->
    computedStyle = window.getComputedStyle fieldDeck
    expect(computedStyle.getPropertyValue 'width').to.be.above '10'
    expect(computedStyle.getPropertyValue 'height').to.be.above '10'
    return

  return
