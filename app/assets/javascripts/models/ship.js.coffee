class Ship
  constructor: (@x, @y)->
    @speedX = 0
    @speedY = 0
    @direction = 'right'

  updateState: ->
    @x += @speedX
    @y += @speedY

window.Ship = Ship