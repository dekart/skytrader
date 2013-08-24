window.Cloud = class
  @generate: ->
    new @(
      Math.random() * mapSize[0]
      Math.random() * mapSize[1]
      Math.random()
    )

  constructor: (@x, @y, @size)->
