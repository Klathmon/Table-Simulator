Polymer 'builder-card', Platform.mixin(
  cardIconPx: 50
  created: ->
    @super()
    return
  ready: ->
    @createDraggabilly()
    return
  domReady: ->
    @setupDraggable()
    @draggie.on 'dragStart', @createGhostElement.bind @
    @draggie.on 'dragMove', @moveGhostElement.bind @
    @draggie.on 'dragEnd', @killGhostElement.bind @
    return

  createGhostElement: (dragInstance, event, pointer)->
    cardComputedStyle = window.getComputedStyle(@)
    @cardWidth = cardComputedStyle.getPropertyValue "width"
    @cardHeight = cardComputedStyle.getPropertyValue "height"

    cardWidth = parseInt(@cardWidth)
    cardHeight = parseInt(@cardHeight)

    [xPos, yPos] = @getMyPosition()
    @offsetX = pointer.pageX - xPos + (cardWidth / 2)
    @offsetY = pointer.pageY - yPos + (cardHeight / 2)
    @trueOffsetX = @offsetX
    @trueOffsetY = @offsetY
    @offsetIconX = @cardIconPx / 2
    @offsetIconY = ((cardHeight / cardWidth) * @cardIconPx) / 2

    @hoverCard = document.createElement 'base-card'
    @hoverCard.imageData = @imageData
    @hoverCard.style.width = @cardWidth
    @hoverCard.style.position = 'absolute'
    @hoverCard.style['z-index'] = '5000'
    @hoverCard.style.opacity = 0
    @setXYPos pointer.pageX, pointer.pageY
    document.body.appendChild @hoverCard
    @notFirstHoverEvent = false
    return
  moveGhostElement: (dragInstance, event, pointer)->
    if @notFirstHoverEvent
      @hoverCard.style.opacity = 1
      @style.opacity = 0
      @setXYPos pointer.pageX, pointer.pageY
      #now get the bounding box of the container, and check if this element is within it
      boundingRect = @parentElement.getBoundingClientRect()
      compStyle = window.getComputedStyle @hoverCard

      x = pointer.pageX - @offsetX + (parseInt(compStyle.getPropertyValue "width") / 2)
      y = pointer.pageY - @offsetY + (parseInt(compStyle.getPropertyValue "height") / 2)
      if (x < boundingRect.left or x > boundingRect.right) or (y < boundingRect.top or y > boundingRect.bottom)
        @hoverCard.style.width = @cardIconPx + 'px'
        @offsetX = @offsetIconX
        @offsetY = @offsetIconY
      else
        @hoverCard.style.width = @cardWidth
        @offsetX = @trueOffsetX
        @offsetY = @trueOffsetY

    @notFirstHoverEvent = true
    return
  killGhostElement: (dragInstance, event, pointer)->
    @style.opacity = 1
    @hoverCard.parentElement.removeChild @hoverCard
    return

  setXYPos: (pageX, pageY)->
    @hoverCard.style.left = (pageX - @offsetX) + 'px'
    @hoverCard.style.top = (pageY - @offsetY) + 'px'
    return
, draggable)
