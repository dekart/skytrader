window.CityController = class extends BaseController
  className: 'city_dialog'

  @show: (args...)->
    @controller ?= new @()
    @controller.show(args...)

  constructor: ->
    super

    @overlay = $("<div class='dialog_overlay'></div>")

  show: (@city, @ship)->
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

  unbindEventListeners: ->
    @el.off('click', '.close', @.onCloseClick)
    @el.off('click', '.buy', @.onBuyClick)
    @el.off('click', '.sell', @.onSellClick)

  onCloseClick: =>
    @.close()

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
