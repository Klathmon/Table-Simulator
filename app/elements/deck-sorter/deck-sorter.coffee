Polymer 'deck-sorter',
  cardElement: "builder-card"
  packery: null
  domReady: ->
    @packery = new Packery @,
      itemSelector: @cardElement
      columnWidth: @cardElement
      rowHeight: @cardElement
      gutter: 8

    @packery.on 'dragItemPositioned', =>
      @layout()
      return

    @onMutation @, @contentChanged
    return

  contentChanged: (observer, mutations)->
    addedElements = []
    removedElements = []
    for mutation in mutations
      addedElements.push addedNode for addedNode in mutation.addedNodes
      removedElements.push removedNode for removedNode in mutation.removedNodes

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
      @packery.layout()
      @asyncFire 'layout-complete',
        'elements': @packery.getItemElements()
      return
    , 200
    return
