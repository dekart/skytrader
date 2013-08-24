#=require ./flying_object

window.Ship = class extends FlyingObject
  maxSpeed: 4
  maxCargo: 10
  maxHealth: 100
  maxFuel: 5

  roundsPerSecond: 2

  constructor: (controller)->
    super(controller, 100, 100)

    @health = @.maxHealth
    @fuel = @.maxFuel
    @fuel_reduced_at = Date.now()

    @money = 200
    @cargo = {}

  updateState: ->
    super

    @.updateFuel()
    @.shoot() if @shooting

  updateFuel: ->
    if Date.now() - @fuel_reduced_at > tenSeconds # 10 seconds!!!
      @fuel_reduced_at = Date.now()
      @fuel -= 1

      if @fuel == 0
        @controller.death()

  shoot: ->
    return if @shot_at and Date.now() - @shot_at < 1000 / @.roundsPerSecond

    @shot_at = Date.now()

    @controller.addBullet(
      new Bullet(@, @x, @y, @controller.mouse_position[0], @controller.mouse_position[1])
    )


  fuelExhaustion: ->
    1 - (Date.now() - @fuel_reduced_at) / tenSeconds

  canDock: ->
    Math.abs(@speedX) < 0.3 and Math.abs(@speedY) < 0.3

  dock: ->
    @docked = true

  undock: ->
    @docked = false
    @fuel_reduced_at = Date.now() # refuel ship

  totalCargo: ->
    total = 0
    total += amount for item, amount of @cargo
    total

  buyCargo: (type, city)->
    if @.totalCargo() >= @.maxCargo
      'not_enough_space'
    else if @money < city.prices[type]
      'not_enough_money'
    else
      @money -= city.prices[type]

      @cargo[type] ?= 0
      @cargo[type] += 1

      city.stock[type] -= 1

      true

  sellCargo: (type, city)->
    if @cargo[type] <= 0
      'not_enough_cargo'
    else
      @money += city.prices[type]

      @cargo[type] -= 1

      city.stock[type] += 1

      true

  getHit: (bullet)->
    @health -= bullet.damage

    @controller.animator.updateHealthProgress()

    if @health <= 0
      @controller.death()

  healthPercent: ->
    @health / @.maxHealth