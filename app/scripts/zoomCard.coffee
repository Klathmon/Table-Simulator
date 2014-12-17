# Requires 'paper-dialog', 'paper-dialog-transition-center', and 'base-card'
# to be imported in the element that uses this
# This also requires the globals.coffee script to be included somewhere
zoomCard =
  zoomCard: ->
    dbox = document.createElement 'paper-dialog'
    dbox.setAttribute 'transition', 'paper-dialog-transition-center'
    dbox.setAttribute 'layered', true
    dbox.setAttribute 'backdrop', true
    dbox.setAttribute 'closeSelector', 'base-card'
    dbox.$.scroller.style.padding = '0'
    dbox.$.scroller.style.overflow = 'hidden'
    dbox.appendChild @createZoomDialogContents()
    dbox.addEventListener 'core-overlay-close-completed', (event)->
      event.target.parentNode.removeChild event.target
      return
    document.body.appendChild dbox
    # use async to set it to opened on the next animation frame.
    # this guarantees that the children are laid out so the dialog can
    # position itself correctly. It fixes a bug where the dialog would be
    # wrongly sized and positioned randomly
    @async ->
      dbox.setAttribute 'opened', true
      @fire 'zoomed-card-added'
      return
    return

  createZoomDialogContents: ->
    card = new BaseCard()
    card.imageData = @imageData
    card.style.width = '100%'
    card.style.height = 'auto'
    return card
