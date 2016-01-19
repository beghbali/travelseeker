window.Zentrips =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
    trips = new Zentrips.Collections.Trips
    trips.fetch
    new Zentrips.Routers.Trips({trips: trips.first})
    Backbone.history.start()

$(document).ready ->
  Zentrips.initialize()
