class @TripNotesForm extends React.Component
  mixins: [Backbone.React.Utils.Autosave.mixin]

  @propTypes =
    model: React.PropTypes.instanceOf(Zentrips.Models.Trip).isRequired

  handleChange: ->
    this.props.model.set { notes: this.refs.input.getValue() }

  submit: ->
    handleChange()

  classNames: ->
    if @state.loading then 'warning' else 'success'

  render: ->
    form = new Backbone.Form
      model: @props.model

    #`<div dangerouslySetInnerHTML={{__html: form.render().el.outerHTML }} />`
    Input = ReactBootstrap.Input

    `<Input
        type="textarea"
        value={this.state.value}
        placeholder="Type in any general notes about your trip to organize your thoughts"
        label={false}
        bsStyle={this.classNames()}
        hasFeedback
        ref="input"
        onChange={this.handleChange.bind(this)} />`

reactMixin.onClass(@TripNotesForm, Backbone.React.Utils.Autosave.mixin)
