#= require ./flying_object

window.Bullet = class extends FlyingObject
  maxSpeed: 6
  lifetime: 1000
  damage: 1

  constructor: (@source, x, y, to_x, to_y)->
    super(@source.controller, x, y)

    dx = to_x - x
    dy = to_y - y

    @speedX = Math.sqrt(
      Math.pow(@.maxSpeed, 2) / (1 + Math.pow(dy / dx , 2) )
    ) * Math.sign(dx)

    @speedY = Math.sqrt(
      Math.pow(@.maxSpeed, 2) / (1 + Math.pow(dx / dy , 2) )
    ) * Math.sign(dy)

    @shot_at = Date.now()


  updateState: ->
    @.updateDirection()
    @.updatePosition()

    if @source instanceof Pirate and Math.hypo(@controller.ship.x - @x, @controller.ship.y - @y) < 20
      @controller.animator.bulletHit(@)

      @controller.ship.getHit(@)

      @remove = true
    else if @source instanceof Ship
      for pirate in @controller.pirates
        if Math.hypo(pirate.x - @x, pirate.y - @y) < pirate.hitDistance
          @controller.animator.bulletHit(@)

          pirate.getHit(@)

          @remove = true

          break

    if Date.now() - @shot_at > @.lifetime
      @remove = true

