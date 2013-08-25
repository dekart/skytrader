window.CityController = class extends BaseController
  className: 'city_dialog'

  @show: (args...)->
    @controller ?= new @()
    @controller.show(args...)

  constructor: ->
    super

    @overlay = $("<div class='dialog_overlay'></div>")

  show: (@map, @city, @ship)->
    @ship.dock()
    @city.shipDocks()

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
      @.renderTemplate('city')
    )

  renderError: (text)->
    @error ?= $("<div class='error'></div>")

    @error.html(text).css(opacity: 1).appendTo(@el)

    @error.stop(true).delay(1000).fadeTo(400, 0, ()=> @error.detach())

  setupEventListeners: ->
    @el.on('click', '.close', @.onCloseClick)
    @el.on('click', '.buy', @.onBuyClick)
    @el.on('click', '.sell', @.onSellClick)
    @el.on('click', '.refuel', @.onRefuelClick)
    @el.on('click', '.repair', @.onRepairClick)

    $(document).on('keydown', @.onKeyDown)

  unbindEventListeners: ->
    @el.off('click', '.close', @.onCloseClick)
    @el.off('click', '.buy', @.onBuyClick)
    @el.off('click', '.sell', @.onSellClick)

    $(document).off('keydown', @.onKeyDown)

  onCloseClick: =>
    @.close()

  onKeyDown: (e)=>
    console.log(e)
    @.close() if e.keyCode == 27

  onBuyClick: (e)=>
    type = $(e.currentTarget).data('type')

    result = @ship.buyCargo(type, @city)

    if result == true
      @.render()
    else
      @.renderError(I18n.t("game.city.errors.#{ result }"))

  onSellClick: (e)=>
    type = $(e.currentTarget).data('type')

    result = @ship.sellCargo(type, @city)

    if result == true
      @.render()
    else
      @.renderError(I18n.t("game.city.errors.#{ result }"))

  onRefuelClick: (e)=>
    result = @ship.refuel()

    if result == true
      @.render()
    else
      @.renderError(I18n.t("game.city.errors.#{ result }"))

  onRepairClick: (e)=>
    result = @ship.repair()

    if result == true
      @.render()
    else
      @.renderError(I18n.t("game.city.errors.#{ result }"))
