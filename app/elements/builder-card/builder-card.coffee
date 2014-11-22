Polymer 'builder-card', Platform.mixin(
  created: ->
    @super()
    return
  ready: ->
    @setupDraggable()
    return

  setXYPos: (pageX, pageY)->
    @hoverCard.style.left = (pageX - @offsetX) + 'px'
    @hoverCard.style.top = (pageY - @offsetY) + 'px'
    return
, draggable)
