Polymer 'image-uploader',
  imageType: /image.*/
  imageWidth: 300
  imageHeight: 467
  addIcon: "add"
  importCardHover: ->
    @$.importCardButton.classList.toggle "hovering"
    @addIcon = "create"
  importCardHoverOut: ->
    @$.importCardButton.classList.toggle "hovering"
    @addIcon = "add"
  importCardClicked: ->
    @$.trueFileInput.click()
  fileImported: ->
    files = @$.trueFileInput.files
    fileNumber = files.length - 1
    importInterval = setInterval =>
      file = files[fileNumber]
      fileNumber--
      console.log file
      if typeof file is 'undefined'
        clearInterval importInterval
      else
        if !file.type.match(@imageType)
          alert "Not an image!"
          #TODO: replace this with a fancy dialogue
        else
          @importFile file

      return
    , 10
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
      @fire 'new-image',
        imageData: imageData
