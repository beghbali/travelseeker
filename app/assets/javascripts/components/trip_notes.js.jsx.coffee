class @TripNotes extends React.Component
  mixins: [Backbone.React.Component.mixin]

  @propTypes =
    trip: React.PropTypes.object
    expanded: React.PropTypes.bool

  constructor: (props)->
    super(props)
    @state = { expanded: @props.expanded }

  handleClick: (e)->
    if (e.target instanceof HTMLInputElement || e.target instanceof HTMLTextAreaElement)
      e.preventDefault
    else
      expanded = !@state.expanded
      @setState { expanded:  expanded }
      if expanded then @tripNotesForm.startAutoSave else @tripNotesForm.stopAutoSave

  notesSectionClassNames: ->
    classes = ['notes-section']
    classes.push 'expanded' if @state.expanded
    classes.join(' ')

  render: ->
    `<div onClick={this.handleClick.bind(this)} >
       <div>
         <i className='fa fa-pencil-square-o fa-4'></i>
          <div className={this.notesSectionClassNames()}>
            <TripNotesForm model={new Zentrips.Models.Trip(this.props.trip)} ref={(ref) => this.tripNotesForm = ref} />
          </div>
       </div>
    </div>`

reactMixin.onClass(@TripNotes, Backbone.React.Component.mixin)