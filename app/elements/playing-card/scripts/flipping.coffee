flipCard = (event)->
  event.preventDefault()
  event.stopPropagation()
  @$.container.classList.add("flipping")
  @$.container.classList.toggle("flipped")
  setTimeout(=>
    @$.container.classList.remove("flipping")
  , 600)
