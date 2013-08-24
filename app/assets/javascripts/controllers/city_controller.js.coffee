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

    @visible = false

  render: ->
    @html(
      @.renderTemplate('city')
    )

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

    if @ship.buyCargo(type, @city) == true
      @.render()

  onSellClick: (e)=>
    type = $(e.currentTarget).data('type')

    if @ship.sellCargo(type, @city) == true
      @.render()