document.getElementById('testSpace').innerHTML = '<playing-card><h1>Test Card 1</h1></playing-card>'

document.addEventListener "polymer-ready", ->
  card = document.querySelector('playing-card')
  chai.expect(card.innerHTML).to.equal "<h1>Test Card 1</h1>"

  compStyle = window.getComputedStyle(card, null)

  chai.expect(parseInt(compStyle.getPropertyValue("height"))).to.be.at.least(50)
  chai.expect(parseInt(compStyle.getPropertyValue("width"))).to.be.at.least(50)
  done()
  return
