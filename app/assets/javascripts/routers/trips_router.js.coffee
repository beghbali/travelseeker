class Zentrips.Routers.Trips extends Backbone.Router
  initialize: (options) ->
    @trips = new Zentrips.Collections.Trips
    @trips.reset options.trips

  routes:
    "index"       : "index"
    "new"         : "newtrip"
    ":id"         : "show"
    ":id/edit"    : "edit"
    ".*"          : "index"

  # index: ->
  #   @view = new Zentrips.Views.TripsIndex({collection: @trips})

  # newtrip: ->
  #   @view = new Zentrips.Views.tripsNewView({collection: @trips})

  # show: (id) ->
  #   trip = @trips.get(id)
  #   @view = new Zentrips.Views.tripsShowView({model: trip})

  # edit: (id) ->
  #   trip = @trips.get(id)
  #   @view = new Zentrips.Views.tripsEditView({model: trip})
