Polymer 'deck-sorter',
  cardElement: 'builder-card'
  packery: null
  domReady: ->
    spacer = document.createElement 'div'
    spacer.classList.add 'spacer'
    @appendChild spacer

    @packery = new Packery @,
      itemSelector: @cardElement
      columnWidth: @cardElement
      rowHeight: @cardElement
      gutter: spacer

    @packery.on 'dragItemPositioned', =>
      @layout()
      return

    @onMutation @, @contentChanged
    return

  contentChanged: (observer, mutations)->
    addedElements = []
    removedElements = []
    for mutation in mutations
      for addedNode in mutation.addedNodes
        if addedNode.tagName isnt undefined
          if addedNode.tagName.toLowerCase() isnt @cardElement
            continue
        addedElements.push addedNode
      for removedNode in mutation.removedNodes
        if removedNode.tagName isnt undefined
          if removedNode.tagName.toLowerCase() isnt @cardElement
            continue
        removedElements.push removedNode

    @addElements addedElements
    @removeElements removedElements

    @onMutation @, @contentChanged
    return

  addElements: (addedElements)->
    for element in addedElements
      @packery.bindDraggabillyEvents element.draggie
    @packery.appended addedElements
    @layout()
    return
  removeElements: (addedElements)->
    for element in addedElements
      @packery.remove element
      @layout()
    return

  layout: ->
    @job 'packery-layout-job', =>
      layoutCompleteFunction = =>
        @packery.off 'layoutComplete', layoutCompleteFunction
        @asyncFire 'layout-complete',
          'elements': @packery.getItemElements()
        return
      @packery.on 'layoutComplete', layoutCompleteFunction
      @packery.layout()
      return
    , 200
    return
