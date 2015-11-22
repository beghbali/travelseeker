# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#= require bootstrap-tab
#= require twitter/typeahead
#= require bootstrap-tokenfield
#= require clipmap

$ ->
  available_tags = $('[data-available-tags]').data('available-tags')
  typeahead_engine = new Bloodhound(
    local: available_tags,
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    datumTokenizer: Bloodhound.tokenizers.whitespace
    )
  typeahead_engine.initialize()
  $('[data-tokens]').tokenfield(
    typeahead: [null, { source: typeahead_engine.ttAdapter() }]
    delimeter: ", "
  ).on 'tokenfield:createdtoken tokenfield:removedtoken', (e)->
    $target = $(e.target)
    $target.prop('value', $target.tokenfield('getTokensList'))
    $(e.target.closest('form')).trigger('submit.rails')
