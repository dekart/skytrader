#= require ./map_animator

window.MapController = class extends BaseController
  className: 'map_screen'

  constructor: ->
    super

    @ship = new Ship(0, 0)

    @animator = new MapAnimator(@)

  show: ->
    @.setupEventListeners()

    @.render()

  setupEventListeners: ->
    $(document).on('keydown', @.onClientKeyDown)
    $(document).on('keyup', @.onClientKeyUp)

    $(document).focus()

  render: ->
    @animator.deactivate()

    @el.appendTo('#game')

    @animator.activate()

  onClientKeyDown: (e)=>
    switch e.keyCode
      when 37 #left
        @ship.speedX = -2
        @ship.direction = 'left'
      when 38 # Arrow up
        @ship.speedY = -2
      when 39 #right
        @ship.speedX = 2
        @ship.direction = 'right'
      when 40 # down
        @ship.speedY = 2
      else
        process_default = true

    e.preventDefault() unless process_default?

  onClientKeyUp: (e)=>
    switch e.keyCode
      when 37, 39 #left, right
        @ship.speedX = 0
      when 38, 40 # up, down
        @ship.speedY = 0
      else
        process_default = true

    e.preventDefault() unless process_default?

  updateState: ->
    @ship.updateState()