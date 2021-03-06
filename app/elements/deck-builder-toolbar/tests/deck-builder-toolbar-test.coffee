suite '<deck-builder-toolbar>', ->
  deckGUID = ''

  dbt = document.querySelector 'deck-builder-toolbar'
  img1 = document.querySelector '#img1'
  img2 = document.querySelector '#img2'

  suiteSetup (done)->
    dbt.$.dataStorage.purgeEverything().then ->
      deck = dbt.$.dataStorage.createDeck()
      deckGUID = deck.guid
      deck.addCard img1.src
      deck.addCard img2.src
      dbt.$.dataStorage.saveDeck(deck).then ->
        done()
        return
      , (err)->
        done(err)
        return
      return
    , (err)->
      done(err)
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
    , (err)->
      done(err)
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
    , (err)->
      done(err)
      return
    return

  test 'check select all works', (done)->
    dbt.$.dataStorage.getDeck(deckGUID).then (deck)->
      animationFrameFlush ->
        dbt.selectAll()
        dbt.updateButtons().then ->
          animationFrameFlush -> animationFrameFlush ->
            attrAll = dbt.$.selectAllButton.hasAttribute('disabled')
            expect(attrAll).to.be.true

            selectedLen = dbt.selectedCards.length
            deckLen = deck.cards.length
            expect(selectedLen).to.equal deckLen
            done()
            return
          return
        return
      , (err)->
        done(err)
        return
      return
    , (err)->
      done(err)
      return
    return

  test 'check open copy dialog works', (done)->
    eventT = ->
      dbt.removeEventListener 'core-overlay-open-completed', eventT
      animationFrameFlush ->
        expect(dbt.$.copyDialog.opened).to.be.true
        expect(dbt.$.dialogAffirmButton.disabled).to.be.true
        done()
        return
      return

    dbt.$.copyDialog.addEventListener 'core-overlay-open-completed', eventT
    dbt.openCopyDialog()
    return

  test 'check copy button enabled on good input', (done)->
    dbt.deckToCopyTo = deckGUID
    animationFrameFlush ->
      expect(dbt.$.dialogAffirmButton.disabled).to.be.false
      done()
      return
    return

  test 'check copy selected works', (done)->
    eventT = ->
      dbt.removeEventListener 'deck-saved', eventT
      animationFrameFlush ->
        expect(dbt.$.copyDialog.opened).to.be.false
        expect(dbt.selectedCards).to.have.length 0
        dbt.$.dataStorage.getDeck(deckGUID).then (deck)->
          expect(deck.cards).to.have.length 4
          done()
          return
        , (err)->
          done(err)
          return
        return
      return
    dbt.$.dataStorage.addEventListener 'deck-saved', eventT
    dbt.copySelected()
    return

  test 'check delete selected works', (done)->
    eventThing = ->
      dbt.removeEventListener 'deck-saved', eventThing
      dbt.updateButtons().then ->
        animationFrameFlush ->
          expect(dbt.selectedCards).to.have.length 0
          dbt.$.dataStorage.getDeck(deckGUID).then (deck)->
            expect(deck.cards).to.have.length 0
            done()
            return
          , (err)->
            done(err)
            return
          return
        return
      , (err)->
        done(err)
        return
      return

    dbt.selectAll()
    dbt.updateButtons().then ->
      dbt.addEventListener 'deck-saved', eventThing
      dbt.deleteSelected()
      return
    , (err)->
      done(err)
      return
    return

  return
