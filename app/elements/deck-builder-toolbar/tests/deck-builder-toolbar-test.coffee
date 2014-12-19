dbt = document.querySelector 'deck-builder-toolbar'
img1 = document.querySelector '#img1'
img2 = document.querySelector '#img2'

suite '<deck-builder-toolbar>', ->
  deckGUID = ''
  suiteSetup (done)->
    dbt.$.dataStorage.purgeEverything().then ->
      deck = dbt.$.dataStorage.createDeck()
      deckGUID = deck.guid
      deck.addCard img1.src
      deck.addCard img2.src
      dbt.$.dataStorage.saveDeck(deck).then ->
        done()
        return
      return
    return

  test 'check element has layout', ->
    computedStyle = window.getComputedStyle dbt
    expect(computedStyle.getPropertyValue 'width').to.be.above '10'
    expect(computedStyle.getPropertyValue 'height').to.be.above '10'
    return

  test 'check buttons disabled by default', (done)->
    dbt.deckGUID = deckGUID
    dbt.deckGUIDChanged().then ->
      animationFrameFlush ->
        attrNone = dbt.$.selectNoneButton.hasAttribute('disabled')
        expect(attrNone).to.be.true
        attrCopy = dbt.$.copySelectedButton.hasAttribute('disabled')
        expect(attrCopy).to.be.true
        attrDelete = dbt.$.deleteSelectedButton.hasAttribute('disabled')
        expect(attrDelete).to.be.true
        attrAll = dbt.$.selectAllButton.hasAttribute('disabled')
        expect(attrAll).to.be.false
        done()
        return
      return
    return

  test 'check clear selected works', (done)->
    dbt.$.dataStorage.getDeck(deckGUID).then (deck)->
      dbt.selectedCards.push deck.cards[0]
      animationFrameFlush ->
        dbt.clearSelected()
        animationFrameFlush ->
          expect(dbt.selectedCards).to.have.length 0
          done()
          return
        return
      return
    return

  return
