class TestRunner

  testElements: ->
    retVal = []
    for elementName in @getListItemElements '/elements/'
      path = '/elements/' + elementName + '/tests/'
      for test in @getListItemElements path
        retVal.push path + test
    return retVal

  getListItemElements: (url)->
    retVal = []
    for span in @queryUrlResponseAll url, '#wrapper .view-tiles li span.name'
      text = span.innerHTML
      continue if text is '..'
      continue if text.indexOf('.coffee') > -1
      retVal.push text
    return retVal

  queryUrlResponseAll: (url, selector)->
    request = new XMLHttpRequest()

    request.open('GET', url, false)
    request.send()

    tempDoc = document.createElement('div')
    tempDoc.innerHTML = request.responseText

    return tempDoc.querySelectorAll(selector)
