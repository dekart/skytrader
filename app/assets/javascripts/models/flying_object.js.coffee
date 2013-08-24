window.FlyingObject = class extends Spine.Class
  constructor: (@controller, @x, @y)->
    @accelX = 0
    @accelY = 0
    @speedX = 0
    @speedY = 0
    @direction = 'right'

    @id = _.random(0, 1000000000)

  updateState: ->
    @.updateDirection()
    @.updateSpeed()
    @.updatePosition()

  updateDirection: ->
    if @accelX < 0
      @direction = 'left'
    else if @accelX > 0
      @direction = 'right'

  totalSpeed: ->
    Math.sqrt(Math.pow(@speedX, 2) + Math.pow(@speedY, 2))

  updateSpeed: ->
    if @accelX != 0 and (Math.abs(@speedY) < @.maxSpeed or Math.abs(@speedX) / @speedX != @accelX)
      @speedX += 0.1 * @accelX
    else if @accelX == 0 and Math.abs(@speedX) > 0
      @speedX -= 0.07 * Math.abs(@speedX) / @speedX
      @speedX = 0 if Math.abs(@speedX) < 0.1

    if @accelY != 0 and (Math.abs(@speedY) < @.maxSpeed or Math.abs(@speedY) / @speedY != @accelY)
      @speedY += 0.1 * @accelY
    else if @accelY == 0 and Math.abs(@speedY) > 0
      @speedY -= 0.07 * Math.abs(@speedY) / @speedY
      @speedY = 0 if Math.abs(@speedY) < 0.1

    if @.totalSpeed() > @.maxSpeed
      @speedX = @speedX / @.totalSpeed() * @.maxSpeed
      @speedY = @speedY / @.totalSpeed() * @.maxSpeed

  updatePosition: ->
    @x += @speedX
    @y += @speedY

    @x = 0 if @x < 0
    @x = mapSize[0] if @x > mapSize[0]

    @y = 0 if @y < 0
    @y = mapSize[0] if @y > mapSize[0]
