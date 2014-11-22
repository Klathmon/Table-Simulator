Polymer 'base-card',
  draggie: {}
  created: ->
    @setZindex()
    return
  mouseDown: ->
    @setZindex()
    return
  zoomCard: ->
    dbox = document.createElement "paper-dialog"
    dbox.setAttribute "transition", "core-transition-center"
    dbox.setAttribute "layered", true
    dbox.setAttribute "backdrop", true
    dbox.setAttribute "opened", true
    dbox.setAttribute "closeSelector", "img"
    dbox.style.width = "310px"
    dbox.shadowRoot.querySelector('#scroller').style.padding = '0'
    img = document.createElement "img"
    img.src = @imageData
    img.style.width = "100%"
    img.style.height = "100%"
    dbox.appendChild img
    dbox.addEventListener "core-overlay-close-completed", (event)->
      event.target.parentNode.removeChild event.target
      return
    document.body.appendChild dbox
    return
  setZindex: ()->
    window.currentCardZindex = 1 if typeof window.currentCardZindex is 'undefined'
    if @style['z-index'] < window.currentCardZindex
      window.currentCardZindex++
      @style['z-index'] = window.currentCardZindex
    return
