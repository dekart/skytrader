#= require ./animator

window.MapAnimator = class extends Animator
  loops: # [StartFrame, EndFrame, Speed]
    ship_standby: {frames: [0,  0], speed: 0.3}
    ship_fly: {frames: [0,  0], speed: 0.3}
    pirate_standby: {frames: [0,  0], speed: 0.3}
    pirate_fly: {frames: [0,  0], speed: 0.3}

  constructor: (controller)->
    super(controller)

    @background_layer = new PIXI.DisplayObjectContainer()
    @city_layer = new PIXI.DisplayObjectContainer()
    @ship_layer = new PIXI.DisplayObjectContainer()
    @cloud_layer = new PIXI.DisplayObjectContainer()
    @pirate_layer = new PIXI.DisplayObjectContainer()
    @bullet_layer = new PIXI.DisplayObjectContainer()

    @stage.addChild(@background_layer)
    @stage.addChild(@city_layer)
    @stage.addChild(@ship_layer)
    @stage.addChild(@cloud_layer)
    @stage.addChild(@pirate_layer)
    @stage.addChild(@bullet_layer)

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

    @ship_sprite = @.createShipSprite('standby')

    @ship_layer.addChild(@ship_sprite)

    for cloud in @controller.clouds
      @cloud_layer.addChild(@.createCloudSprite(cloud))

    for city in @controller.cities
      @city_layer.addChild(@.createCitySprite(city))

    for pirate in @controller.pirates
      @pirate_layer.addChild(@.createPirateSprite(pirate, 'standby'))

  addBullet: (bullet)->
    @bullet_layer.addChild(@.createBulletSprite(bullet))

  removeBullet: (bullet)->
    @bullet_layer.removeChild(_.find(@bullet_layer.children, (c)=> c.bullet.id == bullet.id))

  animate: =>
    unless @paused_at
      createjs.Tween.tick(Date.now() - @last_tick)

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
    if @ship_sprite
      if (@controller.ship.speedX != 0 or @controller.ship.speedY != 0) and @ship_sprite.mode != 'fly'
        @ship_layer.removeChild(@ship_sprite)
        @ship_sprite = @.createShipSprite('fly')
        @ship_layer.addChild(@ship_sprite)
      else if (@controller.ship.speedX == 0 and @controller.ship.speedY == 0) and @ship_sprite.mode != 'standby'
        @ship_layer.removeChild(@ship_sprite)
        @ship_sprite = @.createShipSprite('standby')
        @ship_layer.addChild(@ship_sprite)

      if @controller.ship.direction == 'left'
        @ship_sprite.scale.x = -1
      else
        @ship_sprite.scale.x = 1

      @.updateViewportPosition(@ship_sprite, @controller.ship)

    for cloud_sprite in @cloud_layer.children
      @.updateViewportPosition(cloud_sprite, cloud_sprite.cloud)

    for city_sprite in @city_layer.children
      @.updateViewportPosition(city_sprite, city_sprite.city)

    for pirate_sprite in @pirate_layer.children
      if (pirate_sprite.pirate.speedX != 0 or pirate_sprite.pirate.speedY != 0) and pirate_sprite.mode != 'fly'
        @pirate_layer.removeChild(pirate_sprite)
        pirate_sprite = @.createPirateSprite(pirate_sprite.pirate, 'fly')
        @pirate_layer.addChild(pirate_sprite)
      else if (pirate_sprite.pirate.speedX == 0 and pirate_sprite.pirate.speedY == 0) and pirate_sprite.mode != 'standby'
        @pirate_layer.removeChild(pirate_sprite)
        pirate_sprite = @.createPirateSprite(pirate_sprite.pirate, 'standby')
        @pirate_layer.addChild(pirate_sprite)

      if pirate_sprite.pirate.direction == 'left'
        pirate_sprite.scale.x = -1
      else
        pirate_sprite.scale.x = 1

      @.updateViewportPosition(pirate_sprite, pirate_sprite.pirate)

    for bullet_sprite in @bullet_layer.children
      @.updateViewportPosition(bullet_sprite, bullet_sprite.bullet)

  updateViewportPosition: (sprite, object)->
    sprite.position = @.viewportPosition(object)

  viewportPosition: (object)->
    new PIXI.Point(object.x - @viewport.x, object.y - @viewport.y)

  createShipSprite: (mode)->
    sprite = new PIXI.MovieClip(@.loops["ship_#{ mode }"].textures)
    sprite.mode = mode
    sprite.anchor = new PIXI.Point(0.5, 0.5)
    sprite.animationSpeed = @.loops["ship_#{ mode }"].speed
    sprite.play()
    sprite

  createCloudSprite: (cloud)->
    sprite = PIXI.Sprite.fromFrame('cloud.png')
    sprite.anchor = new PIXI.Point(0.5, 0.5)
    sprite.scale.x = cloud.size * 0.9 + 0.3
    sprite.scale.y = cloud.size * 0.9 + 0.3
    sprite.alpha = cloud.size * 0.8
    sprite.position.x = cloud.x
    sprite.position.y = cloud.y
    #sprite.blendMode = PIXI.blendModes.SCREEN
    sprite.cloud = cloud
    sprite

  createCitySprite: (city)->
    sprite = PIXI.Sprite.fromFrame('city.png')
    sprite.anchor = new PIXI.Point(0.5, 0.5)
    sprite.position.x = city.x
    sprite.position.y = city.y
    sprite.city = city
    sprite


  createPirateSprite: (pirate, mode)->
    sprite = new PIXI.MovieClip(@.loops["pirate_#{ mode }"].textures)
    sprite.mode = mode
    sprite.anchor = new PIXI.Point(0.5, 0.5)
    sprite.position.x = pirate.x
    sprite.position.y = pirate.y
    sprite.pirate = pirate
    sprite

  createBulletSprite: (bullet)->
    sprite = PIXI.Sprite.fromFrame('bullet.png')
    sprite.anchor = new PIXI.Point(0.5, 0.5)
    sprite.position.x = bullet.x
    sprite.position.y = bullet.y
    sprite.bullet = bullet
    sprite
