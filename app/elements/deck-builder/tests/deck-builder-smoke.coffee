suite '<deck-builder> Smoke', ->
  test 'check element has layout', ->
    computedStyle = window.getComputedStyle document.querySelector 'deck-builder'
    expect(computedStyle.getPropertyValue 'width').to.be.above '10'
    expect(computedStyle.getPropertyValue 'height').to.be.above '10'
