Polymer 'image-uploader',
  imageType: /image.*/
  imageWidth: 300
  imageHeight: 467
  addIcon: "add"
  importCardHover: ->
    @$.importCardButton.classList.toggle "hovering"
    @addIcon = "create"
    return
  importCardHoverOut: ->
    @$.importCardButton.classList.toggle "hovering"
    @addIcon = "add"
    return
  importCardClicked: ->
    @$.trueFileInput.click()
    return
  trueFileInputClicked: ->
    @$.trueFileInput.value = null
    return
  fileImported: ->
    files = @$.trueFileInput.files
    fileNumber = 0
    importInterval = setInterval =>
      file = files[fileNumber]
      fileNumber++
      if typeof file is 'undefined'
        clearInterval importInterval
      else
        if !file.type.match(@imageType)
          alert "Not an image!"
          #TODO: replace this with a fancy dialogue
        else
          @importFile file

      return
    , 1
    return
  importFile: (file)->
    img = new Image()
    canvas = document.createElement "canvas"
    ctx = canvas.getContext '2d'
    canvas.width = @imageWidth
    canvas.height = @imageHeight

    img.src = window.URL.createObjectURL file
    listener = img.addEventListener "load", =>
      ctx.drawImage img, 0, 0, @imageWidth, @imageHeight
      imageData = canvas.toDataURL file.type
      @asyncFire 'new-image',
        imageData: imageData
      return
    return
