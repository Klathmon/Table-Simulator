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
    for file in @$.trueFileInput.files
      if !file.type.match(@imageType)
        alert "Not an image!"
        #TODO: replace this with a fancy dialogue
      else
        @importFile file
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
