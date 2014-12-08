Polymer 'deck-sorter',
  cardElement: "builder-card"
  packery: null
  domReady: ->
    spacer = document.createElement "div"
    spacer.classList.add "spacer"
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
        continue if addedNode.tagName isnt undefined and addedNode.tagName.toLowerCase() isnt @cardElement
        addedElements.push addedNode
      for removedNode in mutation.removedNodes
        continue if removedNode.tagName isnt undefined and removedNode.tagName.toLowerCase() isnt @cardElement
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
