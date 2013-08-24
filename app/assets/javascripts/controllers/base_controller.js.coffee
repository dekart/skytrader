window.BaseController = class extends Spine.Controller
  helpers: (other_helpers...)->
    @helper_cache ?= _.extend({}, SampleHelper, other_helpers...)

  renderTemplate: (path, attributes...)->
    JST["views/#{ path }"]( _.extend({}, @.helpers(), @, attributes...) )

  updateEventOffsets: (e)->
    return if e.offsetX and e.offsetY

    offset = $(e.currentTarget).offset()

    e.offsetX = e.clientX - offset.left
    e.offsetY = e.clientY - offset.top