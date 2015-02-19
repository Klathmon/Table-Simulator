Polymer 'base-card',
  setZindex: ()->
    window.curCardZindex = 1 if typeof window.curCardZindex is 'undefined'
    if @style['z-index'] < window.curCardZindex or @style['z-index'] is 'auto'
      window.curCardZindex++
      @style['z-index'] = window.curCardZindex
    return
