window.Ship = class
  maxSpeed: 4

  constructor: ->
    @x = 100
    @y = 100
    @accelX = 0
    @accelY = 0
    @speedX = 0
    @speedY = 0
    @direction = 'right'

    @money = 200
    @cargo = {}

  updateState: ->
    if @accelX < 0
      @direction = 'left'
    else if @accelX > 0
      @direction = 'right'

    if @accelX != 0 and Math.abs(@speedX) < @.maxSpeed
      @speedX += 0.1 * @accelX
    else if @accelX == 0 and Math.abs(@speedX) > 0
      @speedX -= 0.07 * Math.abs(@speedX) / @speedX
      @speedX = 0 if Math.abs(@speedX) < 0.1

    if @accelY != 0 and Math.abs(@speedY) < @.maxSpeed
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

  canDock: ->
    Math.abs(@speedX) < 0.3 and Math.abs(@speedY) < 0.3

  buyCargo: (type, city)->
    if @money >= city.prices[type]
      @money -= city.prices[type]

      @cargo[type] ?= 0
      @cargo[type] += 1

      city.stock[type] -= 1

      true
    else
      'not_enough_money'

  sellCargo: (type, city)->
    if @cargo[type] > 0
      @money += city.prices[type]

      @cargo[type] -= 1

      city.stock[type] += 1

      true
    else
      'not_enough_cargo'