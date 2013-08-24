window.City = class
  @generate: ->
    new @(
      Math.ceil(Math.random() * mapSize[0] / 200) * 200
      Math.ceil(Math.random() * mapSize[1] / 200) * 200
    )

  constructor: (@x, @y)->

  canDock: (ship)->
    @x - 50 < ship.x < @x + 50 and @y - 50 < ship.y < @y + 50