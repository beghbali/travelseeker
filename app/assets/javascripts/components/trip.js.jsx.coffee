class @Trip extends React.Component

  @propTypes =
    trip: React.PropTypes.object.isRequired

  render: ->

reactMixin.onClass(@Trip, Backbone.React.Component.mixin)