#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require_tree .
#= require moment
#= require bootstrap-datetimepicker
#= require jquery_nested_form
#= require bootstrap-transitions
#= require bootstrap-collapse
#= require bootstrap-carousel

$ ->
  goto_anchor = $('[data-goto]').data('goto')

  if goto_anchor
    window.location = window.location.href + goto_anchor
  $('.bootstrap_form-datetimepicker').datetimepicker();
  $('.carousel').carousel();

  $('[data-mirror-to]').on 'keyup input', ->
    target = $($(@).data('mirror-to'))
    target.val($(@).val())
