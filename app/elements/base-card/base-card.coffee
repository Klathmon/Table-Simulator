Polymer 'base-card',
  setZindex: ()->
    window.currentCardZindex = 1 if typeof window.currentCardZindex is 'undefined'
    if @style['z-index'] < window.currentCardZindex
      window.currentCardZindex++
      @style['z-index'] = window.currentCardZindex
    return
