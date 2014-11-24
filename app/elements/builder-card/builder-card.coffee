Polymer 'builder-card', Platform.mixin(
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
    cardWidth = cardComputedStyle.getPropertyValue "width"
    cardHeight = cardComputedStyle.getPropertyValue "height"

    [xPos, yPos] = @getMyPosition()
    @offsetX = pointer.pageX - xPos + (parseInt(cardWidth) / 2)
    @offsetY = pointer.pageY - yPos + (parseInt(cardHeight) / 2)

    @hoverCard = document.createElement 'base-card'
    @hoverCard.imageData = @imageData
    @hoverCard.style.width = cardWidth
    @hoverCard.style.position = 'absolute'
    @hoverCard.style['z-index'] = '-50'
    @setXYPos pointer.pageX, pointer.pageY
    document.body.appendChild @hoverCard
    @notFirstHoverEvent = false
    return
  moveGhostElement: (dragInstance, event, pointer)->
    if @notFirstHoverEvent
      @hoverCard.style['z-index'] = '5000'
      @setXYPos pointer.pageX, pointer.pageY
    @notFirstHoverEvent = true
    return
  killGhostElement: (dragInstance, event, pointer)->
    @hoverCard.parentElement.removeChild @hoverCard
    return

  setXYPos: (pageX, pageY)->
    @hoverCard.style.left = (pageX - @offsetX) + 'px'
    @hoverCard.style.top = (pageY - @offsetY) + 'px'
    return
, draggable)
