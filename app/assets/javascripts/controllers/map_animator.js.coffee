#= require ./animator

window.MapAnimator = class extends Animator
  loops: # [StartFrame, EndFrame, Speed]
    ship_standby: {frames: [0,  0], speed: 0.3}
    ship_fly: {frames: [0,  0], speed: 0.3}

  constructor: (controller)->
    super(controller)

    @ship_layer = new PIXI.DisplayObjectContainer()
    @cloud_layer = new PIXI.DisplayObjectContainer()

    @stage.addChild(@ship_layer)
    @stage.addChild(@cloud_layer)


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
    @ship_sprite = @.createShipSprite('standby')

    @ship_layer.addChild(@ship_sprite)

    @cloud_sprites ?= []

    for cloud in @controller.clouds
      @cloud_layer.addChild(@.createCloudSprite(cloud))


  animate: =>
    unless @paused_at
      createjs.Tween.tick(Date.now() - @last_tick)

      @controller.updateState()

      @.updateSpriteStates()

    super

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

      @ship_sprite.position.x = @controller.ship.x
      @ship_sprite.position.y = @controller.ship.y

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
    sprite.position.x = cloud.x
    sprite.position.y = cloud.y
    sprite.blendMode = PIXI.blendModes.SCREEN
    sprite
