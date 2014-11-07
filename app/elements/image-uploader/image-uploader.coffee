Polymer 'image-uploader',
  imageType: /image.*/
  imageWidth: 300
  imageHeight: 467
  ready: ->

  importCardClicked: ->
    @$.trueFileInput.click()
  fileImported: ->
    #TODO: bug here when uploading multiple files, all of the images are always the last one
    for file in @$.trueFileInput.files
      if !file.type.match(@imageType)
        alert "Not an image!"
        #TODO: replace this with a fancy dialogue
      else
        img = new Image()
        canvas = document.createElement "canvas"
        ctx = canvas.getContext '2d'
        canvas.width = @imageWidth
        canvas.height = @imageHeight

        img.src = window.URL.createObjectURL file
        listener = img.addEventListener "load", =>
          ctx.drawImage img, 0, 0, @imageWidth, @imageHeight
          imageData = canvas.toDataURL file.type
          baseCard = document.createElement 'base-card'
          baseCard.imageData = imageData
          document.body.appendChild(baseCard)
