window.StationController = class extends BaseController
  className: 'station_dialog'

  @show: (args...)->
    @controller ?= new @()
    @controller.show(args...)

  constructor: ->
    super

    @overlay = $("<div class='dialog_overlay'></div>")

  show: (@map, @station)->
    @map.ship.dock()

    @.setupEventListeners()

    @el.css(opacity: 0).appendTo('#game')

    @.render()

    @overlay.css(opacity: 0).appendTo('#game').fadeTo(400, 0.7)

    @el.fadeTo(400, 1)

    @visible = true

  close: ->
    @.unbindEventListeners()

    @overlay.detach()
    @el.detach()

    @error?.detach()

    @visible = false

    @map.ship.undock()

  render: ->
    @html(
      @.renderTemplate('station', ship: @map.ship)
    )

  renderError: (text)->
    @error ?= $("<div class='error'></div>")

    @error.html(text).css(opacity: 1).appendTo(@el)

    @error.stop(true).delay(1000).fadeTo(400, 0, ()=> @error.detach())

  setupEventListeners: ->
    @el.on('click', '.close', @.onCloseClick)
    @el.on('click', '.buy', @.onBuyClick)
    @el.on('click', '.refuel', @.onRefuelClick)
    @el.on('click', '.repair', @.onRepairClick)

    $(document).on('keydown', @.onKeyDown)

  unbindEventListeners: ->
    @el.off('click', '.close', @.onCloseClick)
    @el.off('click', '.buy', @.onBuyClick)
    @el.off('click', '.refuel', @.onRefuelClick)
    @el.off('click', '.repair', @.onRepairClick)

    $(document).off('keydown', @.onKeyDown)

  onCloseClick: =>
    @.close()

  onKeyDown: (e)=>
    @.close() if e.keyCode == 27

  onBuyClick: (e)=>
    type = $(e.currentTarget).data('type')

    result = @map.ship.buyUpgrade(type)

    if result[0] == true
      @map.changeShip(result[1])

      @.render()
    else
      @.renderError(I18n.t("game.city.errors.#{ result }"))

  onRefuelClick: (e)=>
    result = @map.ship.refuel()

    if result == true
      @.render()
    else
      @.renderError(I18n.t("game.city.errors.#{ result }"))

  onRepairClick: (e)=>
    result = @map.ship.repair()

    if result == true
      @.render()
    else
      @.renderError(I18n.t("game.city.errors.#{ result }"))

  upgradePrices: ->
    result = []

    for key, [klass, price] of window.shipUpgrades
      result.push(
        type:     key
        current:  (@map.ship instanceof klass)
        name:     I18n.t("game.ships.#{ key }")
        price:    _.max([0, price - @map.ship.price() / 2])
      )

    result