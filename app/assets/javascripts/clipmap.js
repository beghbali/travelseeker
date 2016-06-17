function initAutocomplete(map, input, latitude, longitude) {

  var autocomplete = new google.maps.places.Autocomplete(input);
  autocomplete.bindTo('bounds', map);

  $(input).keypress(function(e) {
    if (e.which == 13) {
      google.maps.event.trigger(autocomplete, 'place_changed');
      return false;
    }
  });
  autocomplete.addListener('place_changed', function(e) {
    $form = latitude.closest('form');

    if ($form.length == 0) {
      $form = $(input).closest('form');
    }

    $submit = $form.find('.btn');
    var place = autocomplete.getPlace();
    // if (!place.geometry) {
    //   if (/https?:/.test(place.name)) {
    //     return true;
    //   }
    //   window.alert("Could not pinpoint that location or point of interest, please select a choice from the autocomplete drop down");
    //   return;
    // }

    if(place != undefined && place.geometry != undefined) {
      $submit.prop('disabled', 'disabled');
      latitude.prop('value', place.geometry.location.lat());
      longitude.prop('value', place.geometry.location.lng());

      $form.find('[id*=external_reference]').prop('value', place.place_id);
      $form.submit();
    }
  });
}

function setZoom(map, location) {
  var geocoder = new google.maps.Geocoder();
  geocoder.geocode( { 'location': location}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      var result = results[0];
      map.setCenter(result.geometry.location);
      var marker = new google.maps.Marker({
          map: map,
              position: result.geometry.location
          });
      if (result.geometry.viewport) {
        map.fitBounds(result.geometry.viewport);
      }
      if (map.getZoom() > 15) {
        map.setZoom(14);
      }
    }
  });
}

function initMap() {

  // Specify features and elements to define styles.
  var styleArray = [
    {
        "featureType": "landscape.natural",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "visibility": "on"
            },
            {
                "color": "#e0efef"
            }
        ]
    },
    {
        "featureType": "poi",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "visibility": "on"
            },
            {
                "hue": "#1900ff"
            },
            {
                "color": "#c0e8e8"
            }
        ]
    },
    {
        "featureType": "road",
        "elementType": "geometry",
        "stylers": [
            {
                "lightness": 100
            },
            {
                "visibility": "simplified"
            }
        ]
    },
    {
        "featureType": "road",
        "elementType": "labels",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "transit.line",
        "elementType": "geometry",
        "stylers": [
            {
                "visibility": "on"
            },
            {
                "lightness": 700
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "all",
        "stylers": [
            {
                "color": "#7dcdcd"
            }
        ]
    }
];
  var centerLat = $('#clipmap').data('center-lat') || 0;
  var centerLng = $('#clipmap').data('center-lng') || 0;

  var center = new google.maps.LatLng(centerLat, centerLng);

  // Create a map object and specify the DOM element for display.
  var map = new google.maps.Map(document.getElementById('clipmap'), {
    center: center,
    styles: styleArray,
    zoom: 13,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    mapTypeControl: false,
    scrollwheel: true,
    scaleControl: true,
    draggable: true,
    navigationControl: true,
    zoomControl: true,
    zoomControlOptions: {
      position: google.maps.ControlPosition.LEFT_BOTTOM
    }
  });

  window.map = map;
  window.markers = [];
  drawPins(map);
}

function removeMarkers(){
  for(i=0; i<window.markers.length; i++){
      window.markers[i].setMap(null);
  }
  window.markers = [];
}

function fitToMarkers(markers) {

  var bounds = new google.maps.LatLngBounds();

  // Create bounds from markers
  for( var index in markers ) {
      var latlng = markers[index].getPosition();
      bounds.extend(latlng);
  }

  // Don't zoom in too far on only one marker
  if (bounds.getNorthEast().equals(bounds.getSouthWest())) {
     var extendPoint1 = new google.maps.LatLng(bounds.getNorthEast().lat() + 0.01, bounds.getNorthEast().lng() + 0.01);
     var extendPoint2 = new google.maps.LatLng(bounds.getNorthEast().lat() - 0.01, bounds.getNorthEast().lng() - 0.01);
     bounds.extend(extendPoint1);
     bounds.extend(extendPoint2);
  }

  map.fitBounds(bounds);

  // Adjusting zoom here doesn't work :/

}

function drawPins(map) {
  var bounds = new google.maps.LatLngBounds();

  var pins = $('.clip.selected');
  removeMarkers();

  var trip = $('.trip.selected').not('.hidden');
  var marker = new google.maps.Marker({
      position: new google.maps.LatLng(trip.data('latitude') || 0, trip.data('longitude') || 0),
      map: map,
      title: trip.data('name'),
    });

  if (pins.length == 0) {
    window.markers.push(marker);
  }

  $.each (pins, function(index, clip) {
    loc = new google.maps.LatLng($(clip).data('latitude') || 0, $(clip).data('longitude') || 0)

    if (isNaN(loc.lat()) || isNaN(loc.lng()) || (loc.lat() == 0 && loc.lng() == 0)) {
      return;
    }

    bounds.extend(loc)

    var infowindow = new google.maps.InfoWindow({
      content: '<h5><a href="" data-open="#'+$(clip).prop('id')+'" onclick="return false;">'+$(clip).data('name')+'</h5>'
    });

    var marker = new google.maps.Marker({
      position: loc,
      map: map,
      title: $(clip).data('name'),
      icon: $(clip).data('icon-path')
    });

    marker.addListener('click', function() {
      infowindow.open(map, marker);
    }.bind(this))
    ;
    window.markers.push(marker);

    if ($(clip).data('active') == true) {
      map.setCenter(loc);
      infowindow.setPosition(marker.getPosition());
      infowindow.open(map,marker);
    }

  });

  fitToMarkers(window.markers);

  if (pins.length == 1) {
    // map.fitBounds(bounds);
    // map.setZoom(map.getZoom()-4);
  } else if (pins.length > 1) {
    map.fitBounds(bounds);
  } else {
    var trip = $('.trip.selected');
    var tripLocation = new google.maps.LatLng($(trip).data('latitude') || 0, $(trip).data('longitude') || 0);
    map.setCenter(tripLocation);
    bounds.extend(tripLocation);
    map.fitBounds(bounds);
    setZoom(map, tripLocation);
  }
  // zoomChangeBoundsListener =
  //   google.maps.event.addListenerOnce(map, 'bounds_changed', function(event) {
  //     var zoom = this.getZoom()
  //       if ( zoom >= 15) {
  //         this.setZoom(14);
  //       } else if (zoom <=8) {
  //         this.setZoom(9);
  //       }
  // });

  var input = /* @type {!HTMLInputElement} */
      $('input.autocomplete-places')[0];
  if (input != undefined) {
    initAutocomplete(map, input, $('#trip_latitude'), $('#trip_longitude'));
  }
}