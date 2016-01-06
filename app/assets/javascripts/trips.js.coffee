# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#= require clipmap

$ ->
  $('.day').on 'click', (e)->
    $(@).toggleClass('active');

  $('.clips > li').on 'click', (e)->
    clipDetails = $(@).children().first();
    trip = clipDetails.closest('.trip');
    trip.toggleClass('hide');
    trip.parent().append(clipDetails);
    clipDetails.toggleClass('hide');

  $('.new_trip').on 'submit', (e)->
    #needs error handling
    e.preventDefault() if !!$(@).find('#trip_latitude').prop('value') || !!$(@).find('#trip_longitude').prop('value')


