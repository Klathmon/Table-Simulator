Polymer 'connection-manager',
  connectionLinkClicked: ->
    @$.connectionLink.select()
  apiKeyChanged: ->
    window.comm = new Peer({key: @apiKey})
    @$.connectButton.disabled = false if window.location.hash != ''

  hostButtonClicked: ->
    window.comm.on 'connection', (connection)->
      connection.on 'open', ->
        connection.on 'data', (data)->
          console.log 'Data Received: ' + data
    @connectionLinkValue = window.location + '#' + window.comm.id
    @$.hostDialog.opened=true
  connectButtonClicked: ->
    if window.location.hash == ''
      @$.errorDialog.opened=true
    else
      @$.connectionStatus.text="Connecting..."
      @$.connectionStatus.duration = 5000
      @$.connectionStatus.opened=true
      timedOutTimeout = setTimeout =>
        @$.errorDialog.opened=true
      , 5000
      connection = window.comm.connect window.location.hash.substr 1
      connection.on 'open', =>
        clearTimeout timedOutTimeout
        @$.connectionStatus.opened=false
        @$.connectionStatus.text="Connected to host!"
        @$.connectionStatus.duration = 3000
        @$.connectionStatus.opened=true
        connection.send("Motherfucking client-to-client data bitch!")
