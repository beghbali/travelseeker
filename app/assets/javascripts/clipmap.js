function initAutocomplete(map, input, latitude, longitude) {

  var autocomplete = new google.maps.places.Autocomplete(input);
  autocomplete.bindTo('bounds', map);

  autocomplete.addListener('place_changed', function() {
    var place = autocomplete.getPlace();
    if (!place.geometry) {
      if (/https?:/.test(place.name)) {
        return true;
      }
      window.alert("Could not pinpoint that location or point of interest, please select a choice from the autocomplete drop down");
      return;
    }

    latitude.prop('value', place.geometry.location.lat);
    longitude.prop('value', place.geometry.location.lng);
  });
}

function setZoom(map, location) {
  var geocoder = new google.maps.Geocoder();
  geocoder.geocode( { 'location': location}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      var result = results[0]
      map.setCenter(result.geometry.location);
      var marker = new google.maps.Marker({
          map: map,
              position: result.geometry.location
          });
      if (result.geometry.viewport)
        map.fitBounds(result.geometry.viewport);
        if (map.getZoom() > 15) map.setZoom(14);
    } else {
      //needs error handling
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
]
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
    },
  });

  window.map = map;
  window.markers = [];
  drawPins(map);
}

function removeMarkers(){
  for(i=0; i<window.markers.length; i++){
      window.markers[i].setMap(null);
  }
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

  var trip = $('.trip.selected');
  var marker = new google.maps.Marker({
      position: new google.maps.LatLng(trip.data('latitude'), trip.data('longitude')),
      map: map,
      title: trip.data('name'),
    });
  window.markers.push(marker);

  $.each (pins, function(index, clip) {
    loc = new google.maps.LatLng($(clip).data('latitude'), $(clip).data('longitude'))

    if (isNaN(loc.lat()) || isNaN(loc.lng())) {
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
    });
    if ($(clip).data('active') == true) {
      infowindow.open(map,marker);
      map.setCenter(loc);
    }
    window.markers.push(marker);
  });

  fitToMarkers(window.markers)

  if (pins.length == 1) {
    // map.fitBounds(bounds);
    // map.setZoom(map.getZoom()-4);
  } else if (pins.length > 1) {
    map.fitBounds(bounds);
  } else {
    var trip = $('.trip.selected');
    var tripLocation = new google.maps.LatLng($(trip).data('latitude'), $(trip).data('longitude'));
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