# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#= require clipmap
#= require clips


$ ->
  $.fn.datepicker.defaults.format = "yyyy-mm-dd";
  initDateRangePicker= ->
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
      clipDetails = $($(@).find('.clip').data('clip-details'));
      $trip = $('.trip.selected').first();
      # $trip.toggleClass('hide');
      $trip.hide("slide", {direction: "left" }, 1000)
      # $trip.parent().append(clipDetails);
      # clipDetails.toggleClass('hide');
      clipDetails.show("slide", { direction: "right" }, 1000).removeClass('hidden');
      clipDetails.data('active', true);
      clipDetails.addClass('selected');
      drawPins(window.map);

  $(document).on 'click', '.clip-details .back', (e)->
    clipDetails = $(@).closest('.clip-details')
    trip = $('.trip.selected').first();
    trip.load('/trips/'+trip.data('id')+'/trip_details');
    trip.show("slide", { direction: "right" }, 1000)
    clipDetails.hide("slide", {direction: "left" }, 1000).addClass('hidden');
    $('.clip').addClass('selected')
    $(clipDetails.data('clip')).data('active', false);
    drawPins(window.map);

  $(document).on 'submit', '.new_trip', (e)->
    #needs error handling
    e.preventDefault() if $(@).find('#trip_latitude').prop('value').length == 0 || $(@).find('#trip_longitude').prop('value').length == 0;

  $(document).on 'click', '.btn.save', ->
    window.signin();


  initDateRangePicker();

  $(document).on 'page:partial-load', ->
    $('.clip.selected').first().data('active', true); #set one of the ones in view to be the active oen
    drawPins(window.map);
    initDateRangePicker();

  $('.trip-selection select').on 'change', ->
    window.location = $(@).prop('value')
