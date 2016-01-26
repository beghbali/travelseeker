# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#= require clipmap
#= require clips

$ ->
  $.fn.datepicker.defaults.format = "yyyy-mm-dd";
  $('.day').on 'click', (e)->
    $(@).toggleClass('active');

  $('.trip').on 'click', '.trip .clips > li', (e)->
    if !$(e.target).is('i')
      clipDetails = $(@).children().first();
      trip = clipDetails.closest('.trip').parents('.trip').first();
      trip.toggleClass('hide');
      trip.parent().append(clipDetails);
      clipDetails.toggleClass('hide');

  $(document).on 'click', '.clip .back', (e)->
    clipDetails = $(@).closest('.clip');
    trip = clipDetails.parent().find('.trip').parents('.trip').first();
    trip.load('/trips/'+trip.data('id')+'/trip_details');
    trip.toggleClass('hide');
    $($(clipDetails).data('ref')).append(clipDetails);
    clipDetails.toggleClass('hide');

  $('.new_trip').on 'submit', (e)->
    #needs error handling
    e.preventDefault() if $(@).find('#trip_latitude').prop('value').length == 0 || $(@).find('#trip_longitude').prop('value').length == 0;

  $('.btn.save').on 'click', ->
    window.signin();

  # $('.datetime-picker').datetimepicker()
  $('.datetime-picker').on 'click', (e)->
    e.preventDefault()
    $(e.target).append($('<input type="text" style="display:initial"></input>').daterangepicker({
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
        data: JSON.stringify({trip: {start_date: picker.startDate, end_date: picker.endDate}})
        success: (data)->
          $(e.target).first('input').remove();
          Trubolinks.replace(data, { change: trip.prop('id')} )
    )
