# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#= require clipmap
#= require clips
$ ->
  $.fn.datepicker.defaults.format = "yyyy-mm-dd";
  $('.day').on 'click', (e)->
    $(@).toggleClass('active');

  $('.trip').on 'click', '.clips > li', (e)->
    clipDetails = $(@).children().first();
    trip = clipDetails.closest('.trip');
    trip.toggleClass('hide');
    trip.parent().append(clipDetails);
    clipDetails.toggleClass('hide');

  $(document).on 'click', '.clip-details .back', (e)->
    clipDetails = $(@).closest('.clip');
    trip = clipDetails.parent().find('.trip');
    trip.load('/trips/'+trip.data('id')+'/trip_details');
    trip.toggleClass('hide');
    $($(clipDetails).data('ref')).append(clipDetails);
    clipDetails.toggleClass('hide');

  $('.new_trip').on 'submit', (e)->
    #needs error handling
    e.preventDefault() if $(@).find('#trip_latitude').prop('value').length == 0 || $(@).find('#trip_longitude').prop('value').length == 0;

  $('.btn.save').on 'click', ->
    window.signin();


