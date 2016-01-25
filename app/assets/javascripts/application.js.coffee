#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require turbolinks.redirect
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
#= require_tree ./views
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

$ ->
  goto_anchor = $('[data-goto]').data('goto')

  if goto_anchor
    window.location = window.location.href + goto_anchor
  $('.bootstrap_form-datetimepicker').datetimepicker();
  $('.carousel').carousel();

  $('[data-mirror-to]').on 'keyup input', ->
    target = $($(@).data('mirror-to'))
    target.val($(@).val())
