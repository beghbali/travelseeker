class Zentrips.Models.Trip extends Backbone.Model
  paramRoot: 'trip'
  urlRoot: '/trips'
  schema:
    notes:   'TextArea'

  toJSON: (options)->
    { notes: this.attributes.notes }
