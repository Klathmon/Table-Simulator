class TestRunner

  setupTests: ()->
    mocha.setup {ui: 'tdd', slow: 2000, timeout: 10000, htmlbase: ''}

  testElements: () ->
    thisObject = this
    Array.prototype.forEach.call thisObject.getListItemElements('/elements/'), (elementName)->

      htmlSuite elementName, ->
        path = '/elements/' + elementName + '/tests/'
        Array.prototype.forEach.call thisObject.getListItemElements(path), (htmlFile)->
          htmlTest path + htmlFile

  getListItemElements: (url)->
    returnVal = []
    Array.prototype.forEach.call this.queryUrlResponseAll(url, '#wrapper .view-tiles li span.name'), (span)->
      text = span.innerHTML
      return if text == '..'
      return if text.indexOf('.coffee') > -1
      returnVal.push text
    return returnVal

  queryUrlResponseAll: (url, selector)->
    request = new XMLHttpRequest()

    request.open('GET', url, false)
    request.send()

    tempDoc = document.createElement('div')
    tempDoc.innerHTML = request.responseText

    return tempDoc.querySelectorAll(selector)
