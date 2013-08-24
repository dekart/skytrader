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


  show: ->
    @.setupEventListeners()

    @.render()

  setupEventListeners: ->
    $(document).on('keydown', @.onKeyDown)
    $(document).on('keyup', @.onKeyUp)

    @el.on('mousedown', 'canvas', @.onMouseDown)
    @el.on('mouseup', 'canvas', @.onMouseUp)
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
        if @ship.canDock()
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

  onMouseDown: =>
    @ship.shooting = true

  onMouseUp: =>
    @ship.shooting = false

  onMouseMove: (e)=>
    @.updateEventOffsets(e)

    @mouse_position = [e.offsetX + @animator.viewport.x, e.offsetY + @animator.viewport.y]

  addBullet: (bullet)->
    @bullets.push(bullet)

    @animator.addBullet(bullet)

  removeBullet: (bullet)=>
    new_bullets = []

    for b in @bullets
      new_bullets.push(b) if b != bullet

    @bullets = new_bullets

    @animator.removeBullet(bullet)

  updateState: ->
    @ship.updateState()

    cloud.updateState() for cloud in @clouds

    pirate.updateState() for pirate in @pirates

    bullet.updateState() for bullet in @bullets

    @.removeBullet(bullet) for bullet in _.select(@bullets, (b)-> b.remove == true )

  death: ->
    @animator.deactivate()

    DeathScreenController.show()