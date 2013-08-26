window.Station = class
  @generate: (controller)->
    new @(
      controller
      _.random(1, mapSize[0] / 250 - 1) * 250 + _.random(-70, 70)
      _.random(1, mapSize[1] / 250 - 1) * 250 + _.random(-70, 70)
    )

  constructor: (@controller, @x, @y)->

  canDock: ->
    @x - 50 < @controller.ship.x < @x + 50 and @y - 50 < @controller.ship.y < @y + 50
