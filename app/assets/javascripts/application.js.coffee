#= require jquery
#= require jquery.turbolinks
#= require jquery_ujs
#= require jquery-easing
#= require turbolinks
#= require react
#= require react-mixin
#= require react_ujs
#= require underscore
#= require backbone
#= require backbone_rails_sync
#= require backbone-react-component
#= require backbone-react-autosave
#= require backbone-forms
#= require backbone-forms-bootstrap
#= require react_bootstrap
#= require zentrips
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./routers
#= require components
#= require moment
#= require bootstrap-datetimepicker
#= require jquery_nested_form
#= require bootstrap-transitions
#= require bootstrap-collapse
#= require bootstrap-carousel
#= require bootstrap-tab
#= require bootstrap-modal
#= require bootstrap-tooltips
#= require bootstrap-dropdown
#= require best_in_place
#= require jquery-ui
#= require best_in_place.jquery-ui

$ ->
  goto_anchor = $('[data-goto]').data('goto')

  if goto_anchor
    window.location = window.location.href + goto_anchor

  $('.carousel').carousel();

  $('[data-mirror-to]').on 'keyup input', ->
    target = $($(@).data('mirror-to'))
    target.val($(@).val())

  window.autosaves = {}
  $(document).on 'change paste keyup', '[data-autosave=true]', (e)->
    timer = window.autosaves[e.target.id]
    clearTimeout(timer) if timer?
    window.autosaves[e.target.id] = setTimeout (->
      $target = $(e.target)
      $($target.closest('form')).trigger('submit.rails')
      ), 600
