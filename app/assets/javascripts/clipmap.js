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

  // Create a map object and specify the DOM element for display.
  var map = new google.maps.Map(document.getElementById('clipmap'), {
    scrollwheel: false,
    // Apply the map style array to the map.
    styles: styleArray,
    zoom: 1,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  });

  var bounds = new google.maps.LatLngBounds();
  var lastActive = new google.maps.LatLng(0,0);

  $.each ($('.clip.selected'), function(index, clip) {
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
      title: $(clip).data('name')
    });

    marker.addListener('click', function() {
      infowindow.open(map, marker);
    });
    if ($(clip).data('active') == true) {
      infowindow.open(map,marker);
      lastActive = loc;
    }
  });

  map.fitBounds(bounds);
  map.panToBounds(bounds);
  map.setCenter(lastActive);
}