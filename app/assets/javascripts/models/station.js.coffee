window.Station = class
  @generate: (controller)->
    new @(
      controller
      Math.ceil(Math.random() * mapSize[0] / 250) * 250
      Math.ceil(Math.random() * mapSize[1] / 250) * 250
    )

  constructor: (@controller, @x, @y)->

  canDock: ->
    @x - 50 < @controller.ship.x < @x + 50 and @y - 50 < @controller.ship.y < @y + 50
