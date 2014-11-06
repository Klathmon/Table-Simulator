Polymer 'playing-card',
  created: ->
    @setZindex()
    @cardwidth = "150px"
  ready: ->
    @style.width = @cardwidth
    # TODO: change this to an array of function names to foreach over
    @rotateMouseDown = rotateMouseDown.bind(this)
    @rotateMouseUp = rotateMouseUp.bind(this)
    @rotateMouseMove = rotateMouseMove.bind(this)
    @rotateGetRad = rotateGetRad
    @dragMouseDown = dragMouseDown.bind(this)
    @dragMouseUp = dragMouseUp.bind(this)
    @dragMouseMove = dragMouseMove.bind(this)
    @flipCard = flipCard.bind(this)

    @setOrigin()


  setOrigin: ()->
    thisStyle = window.getComputedStyle(this)
    @originPosX = parseInt(thisStyle.getPropertyValue("left")) +
      (parseInt(thisStyle.getPropertyValue("width")) / 2)
    @originPosY = parseInt(thisStyle.getPropertyValue("top")) +
    (parseInt(thisStyle.getPropertyValue("height")) / 2)
    @topLeftX = parseInt(thisStyle.getPropertyValue("left"))
    @topLeftY = parseInt(thisStyle.getPropertyValue("top"))

  setZindex: ()->
    if @style['z-index'] < window.currentCardZindex
      window.currentCardZindex++
      @style['z-index'] = window.currentCardZindex
