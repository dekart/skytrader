#= require jquery
#= require jquery_ujs

#= require underscore
#= require visibility
#= require pixi

#= require spine

#= require i18n

#= require_tree ./lib
#= require_tree ./helpers
#= require_tree ./controllers
#= require_tree ./models
#= require_tree ./views

#= require preloadjs

#= require preloader

#= require_self

window.tenSeconds = 10 * 1000

window.canvasSize = {
  width: 800
  height: 550
}

window.mapSize = [3000, 3000]

window.stockPrices = {
  # Agricultural
  food: [5, 20]
  ore:  [10, 30]

  # Industrial
  machines: [30, 60]
  goods:    [20, 50]

  # Cultural
  luxury: [50, 90]
  books:  [25, 55]
}

window.stockPriceRanges = {
  agro: {
    food:     [0, 0.5]
    ore:      [0, 0.5]
    machines: [0.5, 1]
    goods:    [0.25, 0.75]
    luxury:   [0.25, 0.75]
    books:    [0.5, 1]
  }

  industry: {
    food:     [0.25, 0.75]
    ore:      [0.5, 1]
    machines: [0, 0.5]
    goods:    [0, 0.5]
    luxury:   [0.5, 1]
    books:    [0.25, 0.75]
  }

  culture: {
    food:     [0.5, 1]
    ore:      [0.25, 0.75]
    machines: [0.25, 0.75]
    goods:    [0.5, 1]
    luxury:   [0, 0.5]
    books:    [0, 0.5]
  }
}

window.stockAmountRanges = {
  agro: {
    food:     [20, 50]
    ore:      [15, 30]
    machines: [0, 2]
    goods:    [0, 5]
    luxury:   [0, 5]
    books:    [0, 2]
  }

  industry: {
    food:     [0, 10]
    ore:      [0, 5]
    machines: [10, 20]
    goods:    [15, 30]
    luxury:   [0, 2]
    books:    [0, 5]
  }

  culture: {
    food:     [0, 5]
    ore:      [0, 10]
    machines: [0, 5]
    goods:    [0, 3]
    luxury:   [5, 15]
    books:    [10, 25]
  }
}

window.refuelCost = 5
window.repairCost = 1

window.shipUpgrades = {
  sparrow:  [Ship.Sparrow, 500],
  hawk:     [Ship.Hawk, 1500]
  squacco:  [Ship.Squacco, 5000]
}

Math.hypo = (a, b)->
  Math.sqrt(a * a + b * b)

Math.sign = (value)->
  if value == 0
    1
  else
    value / Math.abs(value)

window.Application = class
  start: ->
    $('#preloader').hide()
    $('#game_screen').css(visibility: 'visible')

    @map = new MapController()

    @map.show()

$ =>
  window.preloader = new Preloader(=>
    window.application = new Application()
    window.application.start()

    _gaq?.push(['_trackTiming', 'Game Load', 'Start', Date.now() - load_started_at, null, 100])
  )
