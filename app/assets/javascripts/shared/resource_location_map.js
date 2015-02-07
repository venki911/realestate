var ResourceLocationMap = {
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
    self.$latInput.on('change', function(){
      var lat = $(this).val()
      var pos =  new google.maps.LatLng(lat, self.marker.getPosition().lng())
      self.setPosition(pos)
    })

    self.$lngInput.on('change', function(){
      var lng = $(this).val()
      var pos = new google.maps.LatLng(self.marker.getPosition().lat(), lng)
      self.setPosition(pos)
    })
  },

  updateLatLng: function(){
    var self = this
    var pos = self.marker.getPosition()
    self.$latInput.val(pos.lat())
    self.$lngInput.val(pos.lng())

    var $address = self.$decodedLocation
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
    var self = this
    var lat = self.$latInput.val() || 11.556053345494911
    var lng = self.$lngInput.val() || 104.92063534838871
    var latlng = new google.maps.LatLng(lat, lng)
    return latlng
  },

  createMap: function(){
    var self = this
    var currentLatLon = self.latLon()

    var mapOptions = {
      zoom: 14,
      center: currentLatLon
    }
    self.map = new google.maps.Map(self.$mapCanvas.get(0), mapOptions);

    // Place a draggable marker on the map
    self.marker = new google.maps.Marker({
      draggable:true,
      title:"Drag me to your location!"
    });

    self.marker.setMap(self.map)
    self.setPosition(currentLatLon)
    self.updateLatLng()

    google.maps.event.addListener(self.marker, 'dragend', function(){
      self.updateLatLng()
      self.centerMarker()
    });
  },
  initialize: function(mapCanvas, latInput, lngInput, decodedLocation){
    var self = this
    self.$mapCanvas = $(mapCanvas)
    self.$latInput  = $(latInput)
    self.$lngInput  = $(lngInput)
    self.$decodedLocation = $(decodedLocation)

    self.createMap()
    self.updateMarkerPos()
  },
}