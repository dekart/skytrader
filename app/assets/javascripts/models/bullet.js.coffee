#= require ./flying_object

window.Bullet = class extends FlyingObject
  @include Spine.Events

  maxSpeed: 6
  lifetime: 1000
  damage: 1

  constructor: (controller, x, y, to_x, to_y)->
    super(controller, x, y)

    dx = to_x - x
    dy = to_y - y

    @speedX = Math.sqrt(
      Math.pow(@.maxSpeed, 2) / (1 + Math.pow(dy / dx , 2) )
    ) * (dx / Math.abs(dx))

    @speedY = Math.sqrt(
      Math.pow(@.maxSpeed, 2) / (1 + Math.pow(dx / dy , 2) )
    ) * (dy / Math.abs(dy))

    @shot_at = Date.now()


  updateState: ->
    @.updateDirection()
    @.updatePosition()

    if Math.hypo(@controller.ship.x - @x, @controller.ship.y - @y) < 20
      @controller.ship.getHit(@)

      @remove = true

    if Date.now() - @shot_at > @.lifetime
      @remove = true

