window.Cloud = class
  @generate: (controller)->
    new @(
      controller
      _.random(0, mapSize[0])
      _.random(0, mapSize[1])
      Math.random()
    )

  constructor: (@controller, @x, @y, @size)->

  updateState: ->
    @x -= 0.20 * @size
    @x = mapSize[0] + 150 if @x < -150