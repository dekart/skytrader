window.Cloud = class
  @generate: (controller)->
    new @(
      controller
      Math.random() * mapSize[0]
      Math.random() * mapSize[1]
      Math.random()
    )

  constructor: (@controller, @x, @y, @size)->

  updateState: ->
    @x -= 0.20 * @size
    @x = mapSize[0] + 150 if @x < -150