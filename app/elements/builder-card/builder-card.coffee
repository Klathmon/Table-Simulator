Polymer 'builder-card',
  ready: ->
    @draggie = new Draggabilly @
    return
  checkboxChanged: (event, unknown, element)->
    if element.$.checkbox.classList.contains "checked"
      @classList.add "checked"
    else
      @classList.remove "checked"
    @asyncFire 'checkbox-changed',
      element: @
    return
