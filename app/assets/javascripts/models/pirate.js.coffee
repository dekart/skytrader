#= require ./flying_object

window.Pirate = class extends FlyingObject
  @include Spine.Events

  @generate: (controller)->
    new @(
      controller
      _.random(canvasSize.width, mapSize[0])
      _.random(canvasSize.height, mapSize[1])
    )

  maxSpeed: 3.5
  detectionDistance: 200
  roundsPerSecond: 2

  constructor: (controller, x, y)->
    super(controller, x, y)

    @direction = _.shuffle(['right', 'left'])[0]

  updateState: ->
    distance = Math.hypo(@x - @controller.ship.x, @y - @controller.ship.y)

    if distance < @.detectionDistance
      if @controller.ship.x - @x != 0
        @accelX = (@controller.ship.x - @x) / Math.abs(@controller.ship.x - @x)
      else
        @accelX = 0

      if @controller.ship.y - @y != 0
        @accelY = (@controller.ship.y - @y) / Math.abs(@controller.ship.y - @y)
      else
        @accelY = 0

      @.shoot() unless @controller.ship.docked
    else
      @accelX = 0
      @accelY = 0

    super

  shoot: ->
    return if @shot_at and Date.now() - @shot_at < 1000 / @.roundsPerSecond

    @shot_at = Date.now()

    @controller.addBullet(new Bullet(@controller, @x, @y, @controller.ship.x, @controller.ship.y))
