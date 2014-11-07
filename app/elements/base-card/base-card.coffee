Polymer 'base-card',
  created: ->
    @setZindex()
  ready: ->
    @draggie = new Draggabilly(this,
      #grid: [20,20]
      #containment: true
    )
  mouseDown: ->
    @setZindex()

  setZindex: ()->
    window.currentCardZindex = 1 if typeof window.currentCardZindex == 'undefined'
    if @style['z-index'] < window.currentCardZindex
      window.currentCardZindex++
      @style['z-index'] = window.currentCardZindex
