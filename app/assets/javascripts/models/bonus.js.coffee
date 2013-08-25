#= require ./flying_object

window.Bonus = class extends FlyingObject
  maxSpeed: 1

  constructor: (@controller, x, y)->
    super(@controller, x, y)

    @accelY = 1

  updateState: ->
    super

    if @.canCollect()
      @controller.ship.collectBonus(@)

      @controller.removeBonus(@)
    else if @y > mapSize[1] + 30
      @controller.removeBonus(@)

  canCollect: ->
    Math.hypo(@controller.ship.x - @x, @controller.ship.y - @y) < 25