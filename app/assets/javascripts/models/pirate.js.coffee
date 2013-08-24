#= require ./flying_object

window.Pirate = class extends FlyingObject
  @generate: ->
    new @(
      _.random(canvasSize.width, mapSize[0])
      _.random(canvasSize.height, mapSize[1])
    )

  maxSpeed: 3.5
  detectionDistance: 200

  constructor: (@x, @y)->
    super(@x, @y)

    @direction = _.shuffle(['right', 'left'])[0]

  updateState: (ship)->
    if Math.sqrt(Math.pow(Math.abs(@x - ship.x), 2) + Math.pow(Math.abs(@y - ship.y), 2)) < @.detectionDistance
      if ship.x - @x != 0
        @accelX = (ship.x - @x) / Math.abs(ship.x - @x)
      else
        @accelX = 0

      if ship.y - @y != 0
        @accelY = (ship.y - @y) / Math.abs(ship.y - @y)
      else
        @accelY = 0
    else
      @accelX = 0
      @accelY = 0

    super