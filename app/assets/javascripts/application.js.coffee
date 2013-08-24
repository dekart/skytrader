#= require jquery
#= require jquery_ujs

#= require underscore
#= require visibility
#= require pixi
#= require tweenjs

#= require spine

#= require i18n
#= require i18n/translations

#= require soundmanager2
#= require sounds

#= require_tree ./lib
#= require_tree ./helpers
#= require_tree ./controllers
#= require_tree ./models
#= require_tree ./views

#= require preloadjs

#= require preloader

#= require_self

window.canvasSize = {
  width: 800
  height: 550
}

window.mapSize = [3000, 3000]

window.Application = class
  start: ->
    $('#preloader').hide()
    $('#game_screen').css(visibility: 'visible')

    @map = new MapController()

    @map.show()

$ =>
  window.preloader = new Preloader(=>
    window.application = new Application()
    window.application.start()

    _gaq?.push(['_trackTiming', 'Game Load', 'Start', Date.now() - load_started_at, null, 100])
  )
