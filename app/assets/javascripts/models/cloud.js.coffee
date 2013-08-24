window.Cloud = class
  @generate: (map_width, map_height)->
    new @(
      Math.random() * map_width
      Math.random() * map_height
      Math.random()
    )

  constructor: (@x, @y, @size)->
