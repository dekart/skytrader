window.City = class
  @generate: ->
    new @(
      Math.ceil(Math.random() * mapSize[0] / 200) * 200
      Math.ceil(Math.random() * mapSize[1] / 200) * 200
      _.shuffle(['agro', 'industry', 'culture'])[0]
    )

  constructor: (@x, @y, @type)->
    @prices = {}
    @stock = {}

  canDock: (ship)->
    @x - 50 < ship.x < @x + 50 and @y - 50 < ship.y < @y + 50

  shipDocks: ->
    @.generatePrices()
    @.generateStocks()

  generatePrices: ->
    return if @prices_generated_at and @prices_generated_at > Date.now() - 30*1000 # Keep prices stable during 30 seconds

    @prices_generated_at = Date.now()

    for stock, multiplies of stockPriceRanges[@type]
      price_range = stockPrices[stock]
      price_diff = price_range[1] - price_range[0]

      @prices[stock] = Math.floor(price_range[0] + _.random(price_diff * multiplies[0], price_diff * multiplies[1]))

  generateStocks: ->
    return if @stocks_generated_at and @stocks_generated_at > Date.now() - 30*1000 # Keep stocks stable during 30 seconds

    @stocks_generated_at = Date.now()

    for item, amounts of stockAmountRanges[@type]
      @stock[item] = _.random(amounts...)
