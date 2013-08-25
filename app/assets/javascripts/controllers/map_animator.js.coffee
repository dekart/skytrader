#= require ./animator

window.MapAnimator = class extends Animator
  loops: # [StartFrame, EndFrame, Speed]
    ship_sparrow:       {frames: [0,  3], speed: 0.3}
    ship_hawk:       {frames: [0,  3], speed: 0.3}
    ship_squacco:       {frames: [0,  3], speed: 0.3}
    pirate:     {frames: [0,  3], speed: 0.3}
    city:       {frames: [0,  1], speed: 0.3}
    station:    {frames: [0,  1], speed: 0.2}
    bullet_hit: {frames: [0,  2], speed: 0.2}

  constructor: (controller)->
    super(controller)

    @background_layer = new PIXI.DisplayObjectContainer()
    @city_layer = new PIXI.DisplayObjectContainer()
    @ship_layer = new PIXI.DisplayObjectContainer()
    @cloud_layer = new PIXI.DisplayObjectContainer()
    @pirate_layer = new PIXI.DisplayObjectContainer()
    @bullet_layer = new PIXI.DisplayObjectContainer()
    @explosion_layer = new PIXI.DisplayObjectContainer()
    @interface_layer = new PIXI.DisplayObjectContainer()

    @stage.addChild(@background_layer)
    @stage.addChild(@city_layer)
    @stage.addChild(@ship_layer)
    @stage.addChild(@cloud_layer)
    @stage.addChild(@pirate_layer)
    @stage.addChild(@bullet_layer)
    @stage.addChild(@explosion_layer)
    @stage.addChild(@interface_layer)

    @viewport = new PIXI.Point(0, 0)


  prepareTextures: ->
    for id, animation of @.loops
      animation.textures = []

      for frame in [animation.frames[0] .. animation.frames[1]]
        animation.textures.push(
          PIXI.Texture.fromFrame("#{ id }_#{ @.zeroPad(frame, 4) }.png")
        )

  activate: ->
    return unless super

    @.addSprites()

    @.attachRendererTo(@controller.el)

  addSprites: ->
    @background_sprite = PIXI.Sprite.fromImage('$assetPath(sky.jpg)')

    @background_layer.addChild(@background_sprite)

    @interface_background = PIXI.Sprite.fromFrame('interface.png')
    @interface_background.position = new PIXI.Point(canvasSize.width - 4, 5)
    @interface_background.anchor.x = 1

    @health_progress = new PIXI.Graphics()
    @health_progress.position = new PIXI.Point(canvasSize.width - 85, 10)
    @.updateHealthProgress()

    @fuel_progress = new PIXI.DisplayObjectContainer()
    @fuel_progress.position = new PIXI.Point(canvasSize.width - 196, 14)
    @.updateFuelProgress()

    @cursor = PIXI.Sprite.fromFrame('cursor.png')

    @interface_layer.addChild(@interface_background)
    @interface_layer.addChild(@health_progress)
    @interface_layer.addChild(@fuel_progress)
    @interface_layer.addChild(@cursor)

    @ship_sprite = @.createShipSprite('standby')

    @ship_layer.addChild(@ship_sprite)

    for cloud in @controller.clouds
      @cloud_layer.addChild(@.createCloudSprite(cloud))

    for city in @controller.cities
      @city_layer.addChild(@.createCitySprite(city))

    for station in @controller.stations
      @city_layer.addChild(@.createStationSprite(station))

    for pirate in @controller.pirates
      @pirate_layer.addChild(@.createPirateSprite(pirate))

    @sprites_added = true

  addBullet: (bullet)->
    @bullet_layer.addChild(@.createBulletSprite(bullet))

  removeBullet: (bullet)->
    @bullet_layer.removeChild(_.find(@bullet_layer.children, (c)=> c.source.id == bullet.id))

  bulletHit: (bullet)->
    @explosion_layer.addChild(
      @.createBulletHitSprite(bullet)
    )

  removePirate: (pirate)->
    @pirate_layer.removeChild(_.find(@pirate_layer.children, (c)=> c.source.id == pirate.id))

  animate: =>
    unless @paused_at
      @controller.updateState()

      @.updateViewport()
      @.updateSpriteStates()

    super

  updateViewport: ->
    if @controller.ship.x > canvasSize.width / 2 and @controller.ship.x < mapSize[0] - canvasSize.width / 2
      @viewport.x = @controller.ship.x - canvasSize.width / 2
    else if @controller.ship.x <= canvasSize.width / 2
      @viewport.x = 0
    else
      @viewport.x = mapSize[0] - canvasSize.width

    if @controller.ship.y > canvasSize.height / 2 and @controller.ship.y < mapSize[1] - canvasSize.height / 2
      @viewport.y = @controller.ship.y - canvasSize.height / 2
    else if @controller.ship.y <= canvasSize.height / 2
      @viewport.y = 0
    else
      @viewport.y = mapSize[1] - canvasSize.height

  updateSpriteStates: ->
    return unless @sprites_added

    if (@controller.ship.speedX != 0 or @controller.ship.speedY != 0)
      @ship_sprite.rotation = 20 * Math.PI/ 180 * @controller.ship.totalSpeed() / @controller.ship.maxSpeed
    else if (@controller.ship.speedX == 0 and @controller.ship.speedY == 0)
      @ship_sprite.rotation = 0

    if @controller.ship.direction == 'left'
      @ship_sprite.scale.x = -1
      @ship_sprite.rotation *= -1
    else
      @ship_sprite.scale.x = 1

    @.updateViewportPosition(@ship_sprite, @controller.ship)

    for cloud_sprite in @cloud_layer.children
      @.updateViewportPosition(cloud_sprite, cloud_sprite.source)

    for city_sprite in @city_layer.children
      @.updateViewportPosition(city_sprite, city_sprite.source)

      city_sprite.anchor.y = 0.5 + 0.1 * (
        1 - Math.sin(
          Date.now() / 1000 + city_sprite.source.x + city_sprite.source.y
        )
      )

    for pirate_sprite in @pirate_layer.children
      if (pirate_sprite.source.speedX != 0 or pirate_sprite.source.speedY != 0)
        pirate_sprite.rotation = 20 * Math.PI/ 180 * pirate_sprite.source.totalSpeed() / pirate_sprite.source.maxSpeed
      else if (pirate_sprite.source.speedX == 0 and pirate_sprite.source.speedY == 0)
        pirate_sprite.rotation = 0

      if pirate_sprite.source.direction == 'left'
        pirate_sprite.scale.x = -1
        pirate_sprite.rotation *= -1
      else
        pirate_sprite.scale.x = 1

      @.updateViewportPosition(pirate_sprite, pirate_sprite.source)

    for bullet_sprite in @bullet_layer.children
      @.updateViewportPosition(bullet_sprite, bullet_sprite.source)


    @explosion_layer.removeChild(sprite) for sprite in _.select(@explosion_layer.children, (s)-> s.remove_at < Date.now())

    for sprite in @explosion_layer.children
      @.updateViewportPosition(sprite, sprite.original_position)

    @.updateFuelProgress()
    @.updateCursorPosition()

  updateViewportPosition: (sprite, object)->
    sprite.position = @.viewportPosition(object.x, object.y)

  viewportPosition: (x, y)->
    new PIXI.Point(x - @viewport.x, y - @viewport.y)

  updateHealthProgress: ->
    @health_progress.clear()
    @health_progress.beginFill(0xdd0000, 1)
    @health_progress.drawRect(0, 0, 75 * @controller.ship.healthPercent(), 5)
    @health_progress.endFill()

  updateFuelProgress: ->
    return if @controller.ship.docked

    for i in [0 .. @controller.ship.fuel - 1]
      if @fuel_progress.children[i]
        @fuel_progress.children[i].alpha = 1
      else
        sprite = PIXI.Sprite.fromFrame('fuel.png')
        sprite.position.x = i * (sprite.width + 2)
        sprite.anchor.y = 1
        sprite.blendMode = PIXI.blendModes.SCREEN
        @fuel_progress.addChild(sprite)

    while @fuel_progress.children.length > @controller.ship.fuel
      @fuel_progress.removeChild(@fuel_progress.children[@fuel_progress.children.length - 1])

    if @fuel_progress.children.length > 0
      @fuel_progress.children[@fuel_progress.children.length - 1].alpha = @controller.ship.fuelExhaustion()

  updateCursorPosition: ->
    @cursor.position = @.viewportPosition(
      @controller.mouse_position[0] + @viewport.x
      @controller.mouse_position[1] + @viewport.y
    )

  changeShipSprite: ->
    @ship_layer.removeChild(@ship_sprite)

    @ship_sprite = @.createShipSprite()

    @ship_layer.addChild(@ship_sprite)

  createShipSprite: ->
    sprite = new PIXI.MovieClip(@.loops["ship_#{ @controller.ship.type }"].textures)
    sprite.animationSpeed = @.loops["ship_#{ @controller.ship.type }"].speed
    sprite.play()
    sprite.anchor = new PIXI.Point(0.5, 0.5)
    sprite

  createCloudSprite: (cloud)->
    sprite = PIXI.Sprite.fromFrame('cloud.png')
    sprite.anchor = new PIXI.Point(0.5, 0.5)
    sprite.scale.x = cloud.size * 0.9 + 0.3
    sprite.scale.y = cloud.size * 0.9 + 0.3
    sprite.alpha = cloud.size * 0.8
    sprite.position = new PIXI.Point(cloud.x, cloud.y)
    sprite.source = cloud
    sprite

  createCitySprite: (city)->
    sprite = new PIXI.MovieClip(@.loops.city.textures)
    sprite.animationSpeed = @.loops.city.speed
    sprite.play()
    sprite.anchor = new PIXI.Point(0.5, 0.5)
    sprite.position = new PIXI.Point(city.x, city.y)
    sprite.source = city
    sprite

  createStationSprite: (station)->
    sprite = new PIXI.MovieClip(@.loops.station.textures)
    sprite.animationSpeed = @.loops.station.speed
    sprite.play()
    sprite.anchor = new PIXI.Point(0.5, 0.5)
    sprite.position = new PIXI.Point(station.x, station.y)
    sprite.source = station
    sprite

  createPirateSprite: (pirate)->
    sprite = new PIXI.MovieClip(@.loops.pirate.textures)
    sprite.animationSpeed = @.loops.pirate.speed
    sprite.play()
    sprite.anchor = new PIXI.Point(0.5, 0.5)
    sprite.position = new PIXI.Point(pirate.x, pirate.y)
    sprite.source = pirate
    sprite

  createBulletSprite: (bullet)->
    sprite = PIXI.Sprite.fromFrame('bullet.png')
    sprite.anchor = new PIXI.Point(0.5, 0.5)
    sprite.position = new PIXI.Point(bullet.x, bullet.y)
    sprite.source = bullet
    sprite

  createBulletHitSprite: (bullet)->
    sprite = new PIXI.MovieClip(@.loops["bullet_hit"].textures)
    sprite.position = new PIXI.Point(bullet.x, bullet.y)
    sprite.original_position = new PIXI.Point(bullet.x, bullet.y)
    sprite.anchor = new PIXI.Point(0.5, 0.5)
    sprite.animationSpeed = @.loops["bullet_hit"].speed
    sprite.play()
    sprite.remove_at = Date.now() + 300
    sprite
