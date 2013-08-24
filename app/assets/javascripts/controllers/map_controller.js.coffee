#= require ./map_animator

window.MapController = class extends BaseController
  className: 'map_screen'

  constructor: ->
    super

    @ship = new Ship(100, 100)

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
      when 37, 65 # left
        @ship.accelX = -1
      when 38, 87 # up
        @ship.accelY = -1
      when 39, 68 #right
        @ship.accelX = 1
      when 40, 83 # down
        @ship.accelY = 1
      else
        process_default = true

    e.preventDefault() unless process_default?

  onClientKeyUp: (e)=>
    switch e.keyCode
      when 37, 39, 65, 68 #left, right
        @ship.accelX = 0
      when 38, 40, 87, 83 # up, down
        @ship.accelY = 0
      else
        process_default = true

    e.preventDefault() unless process_default?

  updateState: ->
    @ship.updateState()