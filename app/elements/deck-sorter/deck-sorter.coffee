Polymer 'deck-sorter', Platform.mixin(
  packery: null
  domReady: ->
    @packery = new Packery @,
      itemSelector: "builder-card"
      columnWidth: "builder-card"
      rowHeight: "builder-card"
      gutter: 8

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
      @packery.appended element
      @packery.layout() if @packery.getItemElements().length is 1
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
    , 100
    return

  setXYPos: (pageX, pageY)->
    @hoverCard.style.left = (pageX - @offsetX) + 'px'
    @hoverCard.style.top = (pageY - @offsetY) + 'px'
    return
, draggable)
