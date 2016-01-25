class @TripNotesForm extends React.Component
  # mixins: [Backbone.React.Utils.Autosave.mixin]

  @propTypes =
    model: React.PropTypes.object.isRequired

  constructor: (props)->
    super(props)
    this.state = {loading: false}

  handleChange: ->
    this.props.model.set { notes: this.refs.input.getValue() }

  submit: ->
    handleChange()

  classNames: ->
    if @state.loading then 'warning' else 'success'

  shouldComponentUpdate: (nextProps, nextState)->
    false

  render: ->
    Input = ReactBootstrap.Input

    `<Input
        type="textarea"
        value={this.props.model.attributes.notes}
        placeholder="Type in any general notes about your trip to organize your thoughts"
        label={false}
        bsStyle={this.classNames()}
        hasFeedback
        ref="input"
        onChange={this.handleChange.bind(this)} />`

reactMixin.onClass(@TripNotesForm, Backbone.React.Utils.Autosave.mixin)
