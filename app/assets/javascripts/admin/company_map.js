function companyMap(){
  ResourceLocationMap.initialize('#p-map','#company_lat','#company_lng','#p-formatted-address')
}

if(typeof google != 'undefined')
  google.maps.event.addDomListener(window, 'load', companyMap);
