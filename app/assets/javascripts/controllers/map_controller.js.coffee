#= require ./map_animator
#= require ./death_screen_controller

window.MapController = class extends BaseController
  className: 'map_screen'

  constructor: ->
    super

    @ship = new Ship(@)

    @clouds = []

    for i in [1..100]
      @clouds.push Cloud.generate(@)

    @cities = []

    for i in [1..20]
      @cities.push City.generate(@)

    @pirates = []

    for i in [1..50]
      @pirates.push Pirate.generate(@)

    @bullets = []

    @animator = new MapAnimator(@)

    @mouse_position = [@ship.x + 100, @ship.y]


  show: ->
    @.setupEventListeners()

    @.render()

  setupEventListeners: ->
    $(document).on('keydown', @.onKeyDown)
    $(document).on('keyup', @.onKeyUp)

    @el.on('mousedown', 'canvas', @.onMouseDown)
    @el.on('mouseup',   'canvas', @.onMouseUp)
    @el.on('mousemove', 'canvas', @.onMouseMove)

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
        if @ship.canDock() and not CityController.controller?.visible
          for city in @cities
            CityController.show(@, city, @ship) if city.canDock()
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

  onMouseDown: (e)=>
    e.preventDefault()

    @ship.shooting = true

  onMouseUp: (e)=>
    e.preventDefault()

    @ship.shooting = false

  onMouseMove: (e)=>
    e.preventDefault()

    @.updateEventOffsets(e)

    @mouse_position = [e.offsetX, e.offsetY]

  addBullet: (bullet)->
    @bullets.push(bullet)

    @animator.addBullet(bullet)

  removeBullet: (bullet)->
    new_bullets = []

    for b in @bullets
      new_bullets.push(b) if b != bullet

    @bullets = new_bullets

    @animator.removeBullet(bullet)

  removePirate: (pirate)->
    new_pirates = []

    for p in @pirates
      new_pirates.push(p) if p != pirate

    @pirates = new_pirates

    @animator.removePirate(pirate)

  updateState: ->
    @ship.updateState()

    cloud.updateState() for cloud in @clouds

    pirate.updateState() for pirate in @pirates

    bullet.updateState() for bullet in @bullets

    @.removeBullet(bullet) for bullet in _.select(@bullets, (b)-> b.remove == true )

  death: ->
    @animator.deactivate()

    DeathScreenController.show()