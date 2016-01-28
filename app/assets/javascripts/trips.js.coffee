# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#= require clipmap
#= require clips

$ ->
  $.fn.datepicker.defaults.format = "yyyy-mm-dd";
  $(document).on 'click', '.day', (e)->
    $(@).toggleClass('active');

  $(document).on 'click', '.trip .trip .clips > li', (e)->
    if !$(e.target).is('i')
      clipDetails = $(@).children().first();
      trip = $('.trip.selected').first();
      trip.toggleClass('hide');
      trip.parent().append(clipDetails);
      clipDetails.toggleClass('hide');
      subtrip = clipDetails.data('trip');
      $('.clip[data-trip!='+subtrip+']').removeClass('selected');
      $('.clip[data-trip='+subtrip+']').addClass('selected');
      clipDetails.attr('data-active', true);
      initMap();

  $(document).on 'click', '.clip .back', (e)->
    clipDetails = $(@).closest('.clip');
    trip = $('.trip.selected').first();
    trip.load('/trips/'+trip.data('id')+'/trip_details');
    trip.toggleClass('hide');
    $($(clipDetails).data('ref')).append(clipDetails);
    clipDetails.toggleClass('hide');
    subtrip = clipDetails.data('trip');
    $('.clip').addClass('selected')
    clipDetails.attr('data-active', false);
    initMap();

  $(document).on 'submit', '.new_trip', (e)->
    #needs error handling
    e.preventDefault() if $(@).find('#trip_latitude').prop('value').length == 0 || $(@).find('#trip_longitude').prop('value').length == 0;

  $(document).on 'click', '.btn.save', ->
    window.signin();

  # $('.datetime-picker').datetimepicker()
  $(document).on 'click', '.datetime-picker', (e)->
    e.preventDefault()
    $input = $('<input type="text" style="display:initial"></input>');
    $(e.target).append($input.daterangepicker({
      locale: {
        format: 'YYYY-MM-DD'
      },
      startDate: $(e.target).data('startdate') || '2016-01-01',
      endDate: $(e.target).data('enddate') || '2016-12-31',
      opens: 'left',
      autoApply: true
    }).on 'apply.daterangepicker', (e, picker)->
      trip = $(e.target).closest('.trip');

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
          $(e.target).first('input').remove();
          Turbolinks.replace(data, { change: trip.prop('id')} )
        complete: (xhr, status)->
          console.log(status)
    )
