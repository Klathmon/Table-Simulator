rotateMouseDown = (event)->
  event.preventDefault()
  event.stopPropagation()
  @rotateHandleX = event.pageX
  @rotateHandleY = event.pageY
  window.addEventListener("mousemove", @rotateMouseMove)
  window.addEventListener("mouseup", @rotateMouseUp)

rotateMouseUp = (event)->
  window.removeEventListener("mousemove", @rotateMouseMove)
  window.removeEventListener("mouseup", @rotateMouseUp)
  @rotateLastAngle = @rotateGetRad(event.pageX, event.pageY)

rotateMouseMove = (event)->
  degree = (@rotateGetRad(event.pageX, event.pageY) * (360 / (2 * Math.PI)))
  ['-ms-', '-webkit-', ''].forEach((prefix)=>
      @style[prefix + 'transform'] = 'rotate(' + degree + 'deg)'
      @style[prefix + 'transform-origin'] = '50% 50%'
    )

rotateGetRad = (currX, currY) ->
  rad = Math.atan2(currY - this.originPosY, currX - this.originPosX)
  rad -= Math.atan2(this.rotateHandleY - this.originPosY, this.rotateHandleX - this.originPosX)
  rad += this.rotateLastAngle || 0
  return rad
