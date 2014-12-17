Polymer 'base-card',
  setZindex: ()->
    window.curCardZindex = 1 if typeof window.currentCardZindex is 'undefined'
    if @style['z-index'] < window.curCardZindex
      window.curCardZindex++
      @style['z-index'] = window.curCardZindex
    return
