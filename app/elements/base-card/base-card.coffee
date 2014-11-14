Polymer 'base-card',
  draggie: {}
  created: ->
    @setZindex()
  ready: ->
    @draggie = new Draggabilly(this)
    @draggie.on 'dragEnd', (dragIns, event, pointer)=>
      [xPos, yPos] = @getMyPosition()
      cardComputedStyle = window.getComputedStyle(@)
      @fire 'dragEnd',
        "parent": @parentNode
        "xPos": xPos + "px"
        "yPos": yPos + "px"
        "width": cardComputedStyle.getPropertyValue "width"
        "height": cardComputedStyle.getPropertyValue "height"
    return
  mouseDown: ->
    @setZindex()
  zoomCard: ->
    dbox = document.createElement "core-overlay"
    dbox.style.width = "310px"
    dbox.style.height = "477px"
    dbox.style.overflow = "hidden"
    dbox.setAttribute "transition", "core-transition-center"
    dbox.setAttribute "opened", true
    dbox.setAttribute "backdrop", false
    dbox.setAttribute "layered", true
    dbox.setAttribute "closeSelector", "img"
    img = document.createElement "img"
    img.src = @imageData
    img.style.width = "100%"
    img.style.height = "100%"
    dbox.appendChild img
    dbox.addEventListener "core-overlay-close-completed", (event)->
      event.target.parentNode.removeChild event.target
    document.body.appendChild dbox
  setZindex: ()->
    window.currentCardZindex = 1 if typeof window.currentCardZindex == 'undefined'
    if @style['z-index'] < window.currentCardZindex
      window.currentCardZindex++
      @style['z-index'] = window.currentCardZindex
  getMyPosition: ->
    xPos = 0
    yPos = 0
    element = @
    while element
      xPos += (element.offsetLeft - element.scrollLeft + element.clientLeft)
      yPos += (element.offsetTop - element.scrollTop + element.clientTop)
      element = element.offsetParent
    return [xPos, yPos]
