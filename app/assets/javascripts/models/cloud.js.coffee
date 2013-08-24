window.Cloud = class
  @generate: ->
    new @(
      Math.random() * mapSize[0]
      Math.random() * mapSize[1]
      Math.random()
    )

  constructor: (@x, @y, @size)->

  updateState: ->
    @x -= 0.15 * @size
    @x = mapSize[0] if @x < 0