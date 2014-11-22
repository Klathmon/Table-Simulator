
imageUploader = document.querySelector 'image-uploader'
img = document.querySelector 'img'
img.style.display = "none"
window.addEventListener "polymer-ready", ->
  suite '<image-uploader>', ->

    test 'check-element-has-layout', ->
      computedStyle = window.getComputedStyle imageUploader
      expect(computedStyle.getPropertyValue 'width').to.be.above '10'
      expect(computedStyle.getPropertyValue 'height').to.be.above '10'
