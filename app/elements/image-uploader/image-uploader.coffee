Polymer 'image-uploader',
  imageType: /image.*/
  imageWidth: window.imageStorageSize.width
  imageHeight: window.imageStorageSize.height
  addIcon: 'add'
  importCardHover: ->
    @$.importCardButton.classList.toggle 'hovering'
    @addIcon = 'create'
    return
  importCardHoverOut: ->
    @$.importCardButton.classList.toggle 'hovering'
    @addIcon = 'add'
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
        if not file.type.match(@imageType)
          alert '"' + file.name + '" is not an image, skipping...'
          #TODO: replace this with a fancy dialogue
        else
          @importFile window.URL.createObjectURL(file), file.type
      return
    , 1
    return
  importFile: (fileData, fileType)->
    img = new Image()
    canvas = document.createElement 'canvas'
    ctx = canvas.getContext '2d'
    canvas.width = @imageWidth
    canvas.height = @imageHeight

    img.src = fileData
    listener = img.addEventListener 'load', =>
      ctx.drawImage img, 0, 0, @imageWidth, @imageHeight
      imageData = canvas.toDataURL fileType
      @asyncFire 'new-image',
        imageData: imageData
      return
    return
