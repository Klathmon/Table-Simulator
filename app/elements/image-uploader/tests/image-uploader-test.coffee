suite '<image-uploader>', ->
  imageUploader = document.querySelector 'image-uploader'
  img = document.querySelector 'img'

  test 'check element has layout', ->
    computedStyle = window.getComputedStyle imageUploader
    expect(computedStyle.getPropertyValue 'width').to.be.above '10'
    expect(computedStyle.getPropertyValue 'height').to.be.above '10'
    return

  test 'check image uploads resize', (done)->
    imageUploader.addEventListener 'new-image', (event)->
      sizedImg = document.createElement 'img'
      sizedImg.src = event.detail.imageData
      sizedImg.addEventListener 'load', ->
        computedStyle = window.getComputedStyle sizedImg
        width = parseInt(computedStyle.getPropertyValue 'width')
        height = parseInt(computedStyle.getPropertyValue 'height')
        expect(width).to.equal imageUploader.imageWidth
        expect(height).to.equal imageUploader.imageHeight
        done()
        return
      document.body.appendChild sizedImg
      return
    imageUploader.importFile img.src, 'image/jpg'
    return
  return
