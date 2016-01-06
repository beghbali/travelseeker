function initAutocomplete(map) {
   var input = /** @type {!HTMLInputElement} */
      $('.autocomplete-places')[0];

  var autocomplete = new google.maps.places.Autocomplete(input);
  autocomplete.bindTo('bounds', map);

  autocomplete.addListener('place_changed', function() {
    var place = autocomplete.getPlace();
    if (!place.geometry) {
      window.alert("Could not pinpoint that location or point of interest, please select a choice from the autocomplete drop down");
      return;
    }

    $('#trip_latitude').prop('value', place.geometry.location.lat);
    $('#trip_longitude').prop('value', place.geometry.location.lng);
  });
}

function setZoom(map, location) {
  var geocoder = new google.maps.Geocoder();
  geocoder.geocode( { 'location': location}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      map.setCenter(results[0].geometry.location);
      var marker = new google.maps.Marker({
          map: map,
              position: results[0].geometry.location
          });
      if (results[0].geometry.viewport)
        map.fitBounds(results[0].geometry.viewport);
        if (map.getZoom() > 16) map.setZoom(15);
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
    scrollwheel: false,
    // Apply the map style array to the map.
    styles: styleArray,
    zoom: 2,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    mapTypeControl: false
  });

  var bounds = new google.maps.LatLngBounds();
  var lastActive = new google.maps.LatLng(0,0);

  var pins = $('.clip.selected');
  var markers = [];

  $.each (pins, function(index, clip) {
    loc = new google.maps.LatLng($(clip).data('latitude'), $(clip).data('longitude'))

    if (isNaN(loc.lat()) || isNaN(loc.lng())) {
      return;
    }

    bounds.extend(loc)

    var infowindow = new google.maps.InfoWindow({
      content: '<h5><a href="#'+$(clip).prop('id')+'">'+$(clip).data('name')+'</h5>'
    });

    var marker = new google.maps.Marker({
      position: loc,
      map: map,
      title: $(clip).data('name'),
      icon: $('.markers .highlighted').data('path')
    });

    marker.addListener('click', function() {
      infowindow.open(map, marker);
    });
    if ($(clip).data('active') == true) {
      infowindow.open(map,marker);
      lastActive = loc;
    }
    markers.push(marker);
  });

  if(pins.length > 0) {
    map.fitBounds(bounds);
  }

  map.panToBounds(bounds);
  map.setCenter(lastActive);
  initAutocomplete(map);
  setZoom(map, center);
}