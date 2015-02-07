function propertyMap(){
  ResourceLocationMap.initialize('#p-map','#property_lat','#property_lng','#p-formatted-address')
}

if(typeof google != 'undefined')
  google.maps.event.addDomListener(window, 'load', propertyMap);
