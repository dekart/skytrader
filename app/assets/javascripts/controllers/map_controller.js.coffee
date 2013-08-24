#= require ./map_animator

window.MapController = class extends BaseController
  className: 'map_screen'

  constructor: ->
    super

    @ship = new Ship()

    @clouds = []

    for i in [1..100]
      @clouds.push Cloud.generate()

    @cities = []

    for i in [1..20]
      @cities.push City.generate()

    @animator = new MapAnimator(@)


  show: ->
    @.setupEventListeners()

    @.render()

  setupEventListeners: ->
    $(document).on('keydown', @.onKeyDown)
    $(document).on('keyup', @.onKeyUp)

  render: ->
    @animator.deactivate()

    @el.appendTo('#game')

    @animator.activate()

  onKeyDown: (e)=>
    switch e.keyCode
      when 37, 65 # left
        @ship.accelX = -1
      when 38, 87 # up
        @ship.accelY = -1
      when 39, 68 #right
        @ship.accelX = 1
      when 40, 83 # down
        @ship.accelY = 1
      when 13
        if @ship.canDock()
          for city in @cities
            CityController.show(city, @ship) if city.canDock(@ship)
      else
        process_default = true

    e.preventDefault() unless process_default?

  onKeyUp: (e)=>
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
