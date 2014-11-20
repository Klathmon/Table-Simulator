Polymer 'base-card',
  draggie: {}
  created: ->
    @setZindex()
    return
  mouseDown: ->
    @setZindex()
    return
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
    return
  setZindex: ()->
    window.currentCardZindex = 1 if typeof window.currentCardZindex is 'undefined'
    if @style['z-index'] < window.currentCardZindex
      window.currentCardZindex++
      @style['z-index'] = window.currentCardZindex
    return
