Polymer 'builder-card',
  draggie: {}
  hoverWidth: 0
  offsetX: 0
  offsetY: 0
  hoverCard: {}
  notFirstHoverEvent: false
  ready: ->
    @super()
    @draggie.on 'dragStart', (dragIns, event, pointer)=>
      cardComputedStyle = window.getComputedStyle(@)

      [xPos, yPos] = @getMyPosition()
      @offsetX = pointer.pageX - xPos
      @offsetY = pointer.pageY - yPos

      @hoverCard = document.createElement 'base-card'
      @hoverCard.imageData = @imageData
      @hoverCard.draggie.disable()
      @hoverCard.style.width = cardComputedStyle.getPropertyValue "width"
      @hoverCard.style.position = 'absolute'
      @hoverCard.style['z-index'] = '-50'
      @setXYPos pointer.pageX, pointer.pageY
      document.body.appendChild @hoverCard
      @notFirstHoverEvent = false
      return
    @draggie.on 'dragMove', (dragIns, event, pointer)=>
      if @notFirstHoverEvent
        @hoverCard.style['z-index'] = '5000'
        @setXYPos pointer.pageX, pointer.pageY
      @notFirstHoverEvent = true
      return
    @draggie.on 'dragEnd', (dragIns, event, pointer)=>
      @hoverCard.parentElement.removeChild @hoverCard
      return
    return

  setXYPos: (pageX, pageY)->
    @hoverCard.style.left = (pageX - @offsetX) + 'px'
    @hoverCard.style.top = (pageY - @offsetY) + 'px'
    return
