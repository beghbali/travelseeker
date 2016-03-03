# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#= require clipmap
#= require clips


$ ->
  initBestInPlace= ->
    $(".best_in_place").best_in_place();
    $(document).on 'focus', '.name .autocomplete-places input, .address .autocomplete-places input', (e)->
      $input = $(e.target)
      $clip = $input.closest('.clip-details')
      initAutocomplete(window.map, $input[0], $clip.find('#clip_latitude'), $clip.find('#clip_longitude'))

  $.fn.datepicker.defaults.format = "yyyy-mm-dd";
  initDateRangePicker= ->
    $('.bootstrap_form-datetimepicker').datetimepicker({sideBySide: false, allowInputToggle: true, keepOpen: false, format: "YYYY-MM-DD HH:mm Z", useCurrent: false});
    $(document).on 'click', '.datetime-picker',(e) ->
      e.preventDefault();
      $(@).next('input').daterangepicker('show')

    $('.datetime-picker ~ input').daterangepicker({
        locale: {
          format: 'YYYY-MM-DD'
        },
        startDate: $(@).siblings('.datetime-picker').data('startdate') || '2016-01-01',
        endDate: $(@).siblings('.datetime-picker').data('enddate') || '2016-12-31',
        opens: 'left',
        autoApply: true,
        autoUpdateInput: true,
        timePicker: false
      }).on 'apply.daterangepicker', (e, picker)->
        trip = $(@).closest('.trip');

        # Zentrips.Trips.get(trip_id).save({start_date: picker.startDate, end_date: picker.endDate},{patch: true});
        $.ajax
          headers:
            'Accepts' : 'text/javascript'
            'Content-Type' : 'application/json',
            'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
          type: 'PATCH',
          url: '/trips/'+trip.data('id'),
          dataType: 'script'
          format: 'js'
          data: JSON.stringify({trip: {start_date: picker.startDate, end_date: picker.endDate}})
          success: (data)->
            Turbolinks.replace(data, { change: trip.prop('id')} )
          complete: (xhr, status)->
            console.log(status)

  $(document).on 'click', '.day', (e)->
    $(@).toggleClass('active');

  $(document).on 'click', '.subtrips .trip', (e)->
    tripId = $(@).data('id')
    $('.clip[data-trip!='+tripId+']').removeClass('selected');
    $('.clip[data-trip='+tripId+']').addClass('selected');
    drawPins(window.map);

  $(document).on 'click', '.trip .trip .clips > li', (e)->
    if !$(e.target).is('i') && !$(e.target).is('select')
      $clip = $(@).find('.clip')
      clipDetails = $($clip.data('clip-details'));
      $trip = $('.trip.selected').first();
      $trip.addClass('hidden');
      clipDetails.removeClass('hidden');
      $clip.data('active', true);
      $clip.addClass('selected');
      drawPins(window.map);

  $(document).on 'click', '.clip-details .back', (e)->
    clipDetails = $(@).closest('.clip-details')
    $trip = $('.trip.selected').first();
    $trip.load('/trips/'+$trip.data('id')+'/trip_details');
    $trip.removeClass('hidden');
    clipDetails.addClass('hidden');
    $('.clip').addClass('selected')
    $(clipDetails.data('clip')).data('active', false);
    drawPins(window.map);

  $(document).on 'submit', '.new_trip', (e)->
    #needs error handling
    e.preventDefault() if $(@).find('#trip_latitude').prop('value').length == 0 || $(@).find('#trip_longitude').prop('value').length == 0;

  $(document).on 'click', '.save', ->
    window.signin();


  initDateRangePicker();
  initBestInPlace();

  $(document).on 'page:partial-load', ->
    $('.clip.selected').first().data('active', true); #set one of the ones in view to be the active oen
    drawPins(window.map);
    initDateRangePicker();
    initBestInPlace();

  $('.trip-selection select').on 'change', ->
    window.location = $(@).prop('value')

  $('[data-toggle="tooltip"]').tooltip()

