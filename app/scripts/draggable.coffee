draggable =
  createDraggabilly: ->
      @draggie = new Draggabilly this
      return
  setupDraggable: ->
    elementComputedStyle = window.getComputedStyle @
    @elementWidth = parseInt(elementComputedStyle.getPropertyValue "width")
    @elementHeight = parseInt(elementComputedStyle.getPropertyValue "height")

    @draggie.on 'dragStart', @dragStartFire.bind(this)
    @draggie.on 'dragMove', @dragMoveFire.bind(this)
    @draggie.on 'dragEnd', @dragEndFire.bind(this)
    return
  dragStartFire: ->
    [xPos, yPos] = @getMyPosition()
    @asyncFire 'drag-start',
      element: @
      xPos: xPos
      yPos: yPos
    return
  dragMoveFire: ->
    [xPos, yPos] = @getMyPosition()
    @asyncFire 'drag-move',
      element: @
      xPos: xPos
      yPos: yPos
    return
  dragEndFire: ->
    [xPos, yPos] = @getMyPosition()
    @asyncFire 'drag-end',
      element: @
      xPos: xPos
      yPos: yPos
    return
  getMyPosition: ->
    left = 0
    xPos = 0
    top = 0
    yPos = 0
    element = @
    while element
      left += (element.offsetLeft - element.scrollLeft + element.clientLeft)
      top += (element.offsetTop - element.scrollTop + element.clientTop)
      element = element.offsetParent
    xPos = left + (@elementWidth / 2)
    yPos = top + (@elementHeight / 2)
    return [xPos, yPos]
