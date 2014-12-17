window.generateGUID = ->
  d = new Date().getTime() * performance.now()
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
    r = (d + Math.random() * 16) % 16 | 0
    d = Math.floor(d / 16)
    return (if c is 'x' then r else (r & 0x7 | 0x8)).toString(16).toUpperCase()
