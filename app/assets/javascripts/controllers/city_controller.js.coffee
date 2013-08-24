window.CityController = class extends BaseController
  className: 'city_dialog'

  @show: (city)->
    @controller ?= new @()
    @controller.show(city)

  constructor: ->
    super

    @overlay = $("<div class='dialog_overlay'></div>")

  show: (@city)->
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
      @.renderTemplate('city', city: @city)
    )

  setupEventListeners: ->
    @el.on('click', '.close', @.onCloseClick)

  unbindEventListeners: ->
    @el.off('click', '.close', @.onCloseClick)

  onCloseClick: =>
    @.close()