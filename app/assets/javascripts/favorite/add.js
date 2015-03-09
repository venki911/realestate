$(function(){
  addFavorite()
})

function addFavorite(){
  $(".add-favorite").on('click', function(){
    $this = $(this)
    setBtnDisabled($this)
    setNotification("info", "Processing request")
    var propertyId = $this.attr("data-property-id")

    $.ajax({
      method: 'POST',
      url: '/favorites',
      data: {property_id: propertyId},
      success: function() {
        setBtnDisabled($this, "Added to Favorite list")
        setNotification("notice", "Property saved to favorite list")
      },
      error: function(){
        setNotification('alert', "Failed to save this property")
        setBtnEnabled($this)
      }
    })
    return false
  })
}