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

  placeHolder: ->
    "Welcome! Here's a space where you can save general notes about your trip.
    \n\n
    For more structured travel planning, collect ideas from your usual sources, such as friends and TripAdvisor, and then enter them into the search bar above. We automatically plot your ideas on this map and categorize them for you -- they will appear in the column on the right.
    \n\n
    If you like to plan in more detail, use the column on the right to assign ideas to specific days and add specific notes such as booking details. You can also share your plan with friends or travel companions to get their input.
    "

  render: ->
    Input = ReactBootstrap.Input

    `<Input
        type="textarea"
        value={this.props.model.attributes.notes}
        placeholder={this.placeHolder()}
        label={false}
        bsStyle={this.classNames()}
        hasFeedback
        ref="input"
        onChange={this.handleChange.bind(this)} />`

reactMixin.onClass(@TripNotesForm, Backbone.React.Utils.Autosave.mixin)
