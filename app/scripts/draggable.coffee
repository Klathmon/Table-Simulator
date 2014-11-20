draggable =
  setup: ->
    elementComputedStyle = window.getComputedStyle @
    @elementWidth = parseInt(elementComputedStyle.getPropertyValue "width")
    @elementHeight = parseInt(elementComputedStyle.getPropertyValue "height")

    @draggie = new Draggabilly this
    @draggie.on 'dragStart', @dragStartFire
    @draggie.on 'dragMove', @dragMoveFire
    @draggie.on 'dragEnd', @dragEndFire
    return
  dragStartFire: ->
    [xPos, yPos] = @getMyPosition()
    @asyncFire 'drag-start',
      element: @
      parent: @parentNode
      xPos: xPos
      yPos: yPos
    return
  dragMoveFire: ->
    [xPos, yPos] = @getMyPosition()
    @asyncFire 'drag-move',
      element: @
      parent: @parentNode
      xPos: xPos
      yPos: yPos
    return
  dragEndFire: ->
    [xPos, yPos] = @getMyPosition()
    @asyncFire 'drag-end',
      element: @
      parent: @parentNode
      xPos: xPos
      yPos: yPos
    return
  getMyPosition: ->
    left = xPos = top = yPos = 0
    element = @
    while element
      left += (element.offsetLeft - element.scrollLeft + element.clientLeft)
      top += (element.offsetTop - element.scrollTop + element.clientTop)
      element = element.offsetParent
    xPos = left + (@elementWidth / 2)
    yPos = top + (@elementHeight / 2)
    return [xPos, yPos]
