imageUploader = document.querySelector 'image-uploader'
img = document.querySelector 'img'
window.addEventListener "polymer-ready", ->
  suite '<image-uploader>', ->

    test 'check element has layout', ->
      computedStyle = window.getComputedStyle imageUploader
      expect(computedStyle.getPropertyValue 'width').to.be.above '10'
      expect(computedStyle.getPropertyValue 'height').to.be.above '10'

    test 'check image uploads resize', (done)->
      imageUploader.addEventListener 'new-image', (event)->
        sizedImg = document.createElement 'img'
        sizedImg.src = event.detail.imageData
        sizedImg.addEventListener 'load', ->
          computedStyle = window.getComputedStyle sizedImg
          expect(parseInt(computedStyle.getPropertyValue 'width')).to.equal imageUploader.imageWidth
          expect(parseInt(computedStyle.getPropertyValue 'height')).to.equal imageUploader.imageHeight
          done()
        document.body.appendChild sizedImg
      imageUploader.importFile img.src, 'image/jpg'
