#=require ./flying_object

window.Ship = class extends FlyingObject
  maxSpeed: 4
  maxCargo: 10
  maxHealth: 100

  constructor: (controller)->
    super(controller, 100, 100)

    @money = 200
    @health = @.maxHealth
    @cargo = {}

  updateState: ->
    super

  canDock: ->
    Math.abs(@speedX) < 0.3 and Math.abs(@speedY) < 0.3

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