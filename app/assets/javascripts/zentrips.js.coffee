window.Zentrips =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  Trips: []
  initialize: ->
    # trips = new Zentrips.Collections.Trips
    # trips.fetch
    @Trips = new Zentrips.Collections.Trips($('[data-trip]').data('trip'))
    new Zentrips.Routers.Trips({trips: @Trips})
    Backbone.history.start()

$(document).ready ->
  Zentrips.initialize()
