class Zentrips.Models.Trip extends Backbone.Model
  paramRoot: 'trip'
  urlRoot: '/trips'
  schema:
    notes:   'TextArea'
  idAttribute: 'slug'

  toJSON: (options)->
    { notes: this.attributes.notes, start_date: this.attributes.start_date, end_date: this.attributes.end_date }

