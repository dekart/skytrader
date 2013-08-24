window.DeathScreenController = class extends BaseController
  className: 'death_screen'

  @show: (args...)->
    @controller ?= new @()
    @controller.show(args...)

  constructor: ->
    super

    @overlay = $("<div class='dialog_overlay'></div>")

  show: ->
    @.setupEventListeners()

    @el.css(opacity: 0).appendTo('#game')

    @.render()

    @overlay.css(opacity: 0).appendTo('#game').fadeTo(400, 0.7)

    @el.fadeTo(400, 1)

    @visible = true


  render: ->
    @html(
      @.renderTemplate('death_screen')
    )

  setupEventListeners: ->
    @el.on('click', '.restart', @.onRestartClick)

  onRestartClick: (e)=>
    document.location = document.location
