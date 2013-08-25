#=require ./flying_object

window.Ship = class extends FlyingObject
  constructor: (controller)->
    super(controller, 100, 100)

    @health = @.maxHealth
    @fuel = @.maxFuel
    @fuel_reduced_at = Date.now()

    @money = 500
    @cargo = {}
    @docked = false

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
      new Bullet(@, @x, @y
        @controller.mouse_position[0] + @controller.animator.viewport.x
        @controller.mouse_position[1] + @controller.animator.viewport.y
      )
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

  refuel: ->
    price = (@.maxFuel - @fuel) * refuelCost

    if @money < price
      'not_enough_money'
    else
      @money -= price
      @fuel = @.maxFuel

      true

  repair: ->
    price = (@.maxHealth - @health) * repairCost

    if @money < price
      'not_enough_money'
    else
      @money -= price
      @health = @.maxHealth

      true

  price: ->
    _.find(_.pairs(window.shipUpgrades), ([k, v])=> v[0] == @.constructor )[1][1]

  buyUpgrade: (type)->
    price = window.shipUpgrades[type][1] - @.price() / 2

    if @money < price
      [false, 'not_enough_money']
    else
      @money -= price

      new_ship = new window.shipUpgrades[type][0](@controller)
      new_ship.money = @money
      new_ship.cargo = @cargo
      new_ship.docked = true
      new_ship.x = @x
      new_ship.y = @y

      [true, new_ship]