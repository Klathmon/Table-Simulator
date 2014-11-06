dragMouseDown = (event)->
  event.preventDefault()
  event.stopPropagation()
  @setZindex()
  @setOrigin(this)
  @dragOffsetX = event.pageX - @topLeftX
  @dragOffsetY = event.pageY - @topLeftY
  window.addEventListener("mousemove", @dragMouseMove)
  window.addEventListener("mouseup", @dragMouseUp)

dragMouseUp = (event)->
  window.removeEventListener("mousemove", @dragMouseMove)
  window.removeEventListener("mouseup", @dragMouseUp)
  @setOrigin()

dragMouseMove = (event)->
  @style.top = (event.pageY - @dragOffsetY) + "px"
  @style.left = (event.pageX - @dragOffsetX) + "px"
