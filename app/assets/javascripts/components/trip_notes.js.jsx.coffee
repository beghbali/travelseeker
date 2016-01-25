class @TripNotes extends React.Component

  @propTypes =
    trip: React.PropTypes.object.isRequired
    expanded: React.PropTypes.bool

  constructor: (props)->
    super(props)
    @state = { expanded: @props.expanded, trip: new Zentrips.Models.Trip(@props.trip) }

  handleClick: (e)->
    if (e.target instanceof HTMLInputElement || e.target instanceof HTMLTextAreaElement)
      e.preventDefault
    else
      expanded = !@state.expanded
      @setState { expanded:  expanded }
      if expanded then @tripNotesForm.startAutoSave() else @tripNotesForm.stopAutoSave()

  notesSectionClassNames: ->
    classes = ['notes-section']
    classes.push 'expanded' if @state.expanded
    classes.join(' ')

  render: ->
    `<div onClick={this.handleClick.bind(this)} >
       <div>
         <i className='fa fa-pencil-square-o fa-4'></i>
          <div className={this.notesSectionClassNames()}>
            <TripNotesForm model={this.state.trip} ref={(ref) => this.tripNotesForm = ref} />
          </div>
       </div>
    </div>`

reactMixin.onClass(@TripNotes, Backbone.React.Component.mixin)