Polymer 'deck-sorter', Platform.mixin(
  packery: null
  domReady: ->
    @packery = new Packery @,
      itemSelector: "builder-card"
      columnWidth: "builder-card"
      rowHeight: "builder-card"
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
      @packery.appended element
      @packery.layout() if @packery.getItemElements().length is 1
      @layout()
    return
  removeElements: (addedElements)->
    for element in addedElements
      @packery.remove element
      @layout()
    return

 dragStarted: (event, object)->
   console.log object
   return

 dragStopped: (event, object)->
   console.log object
   return

  layout: ->
    @job 'packery-layout-job', =>
      @packery.layout()
      @job 'layout-complete', =>
        @asyncFire 'layout-complete',
          'elements': @packery.getItemElements()
        return
      , 500
      return
    , 200
    return
, draggable)
