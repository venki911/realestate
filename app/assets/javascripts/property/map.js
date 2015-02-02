var PropertyMap = {
  marker: false,
  map: false,
  setPosition: function(pos){
    var self = this
    self.marker.setPosition(pos)
    self.centerMarker()
  },

  centerMarker: function(){
    var self = this
    self.map.panTo(self.marker.getPosition())
  },

  updateMarkerPos: function(){
    var self = this
    $("#property_lat").on('change', function(){
      var lat = $(this).val()
      var pos =  new google.maps.LatLng(lat, self.marker.getPosition().lng())
      self.setPosition(pos)
    })

    $("#property_lon").on('change', function(){
      var lon = $(this).val()
      var pos = new google.maps.LatLng(self.marker.getPosition().lat(), lon)
      self.setPosition(pos)
    })
  },
  updateLatLon: function(){
    var self = this
    var pos = self.marker.getPosition()
    $("#property_lat").val(pos.lat())
    $("#property_lon").val(pos.lng())

    var $address = $("#p-formatted-address")
    var geocoder = new google.maps.Geocoder();
    geocoder.geocode({latLng: pos }, function(results, status){
      if (status == google.maps.GeocoderStatus.OK){
        $address.find("#address").html(results[0].formatted_address)
        $address.show()
      }
      else {
        $address.hide();
        setNotification('alert', 'Cannot determine address at this location.' + status)
      }
    });
  },
  latLon: function(){
    var lat = $("#property_lat").val() || 11.556053345494911
    var lon = $("#property_lon").val() || 104.92063534838871
    var latlon = new google.maps.LatLng(lat, lon)
    return latlon
  },

  createMap: function(){
    var self = this
    var currentLatLon = self.latLon()

    var mapOptions = {
      zoom: 14,
      center: currentLatLon
    }
    self.map = new google.maps.Map(document.getElementById("p-map"), mapOptions);

    // Place a draggable marker on the map
    self.marker = new google.maps.Marker({
      draggable:true,
      title:"Drag me to your property location!"
    });

    self.marker.setMap(self.map)
    self.setPosition(currentLatLon)
    self.updateLatLon()

    google.maps.event.addListener(self.marker, 'dragend', function(){
      self.updateLatLon()
      self.centerMarker()
    });
  },
  initialize: function(){
    var self = this
    self.createMap()
    self.updateMarkerPos()
  },
}

function initialize(){
  PropertyMap.initialize()
}

google.maps.event.addDomListener(window, 'load', initialize);
