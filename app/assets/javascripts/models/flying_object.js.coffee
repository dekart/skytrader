window.FlyingObject = class
  constructor: (@x, @y)->
    @accelX = 0
    @accelY = 0
    @speedX = 0
    @speedY = 0
    @direction = 'right'

  updateState: ->
    if @accelX < 0
      @direction = 'left'
    else if @accelX > 0
      @direction = 'right'

    if @accelX != 0 and (Math.abs(@speedX) < @.maxSpeed or Math.abs(@speedX) / @speedX != @accelX)
      @speedX += 0.1 * @accelX
    else if @accelX == 0 and Math.abs(@speedX) > 0
      @speedX -= 0.07 * Math.abs(@speedX) / @speedX
      @speedX = 0 if Math.abs(@speedX) < 0.1

    if @accelY != 0 and (Math.abs(@speedY) < @.maxSpeed or Math.abs(@speedY) / @speedY != @accelY)
      @speedY += 0.1 * @accelY
    else if @accelY == 0 and Math.abs(@speedY) > 0
      @speedY -= 0.07 * Math.abs(@speedY) / @speedY
      @speedY = 0 if Math.abs(@speedY) < 0.1

    @x += @speedX
    @y += @speedY

    @x = 0 if @x < 0
    @x = mapSize[0] if @x > mapSize[0]

    @y = 0 if @y < 0
    @y = mapSize[0] if @y > mapSize[0]
