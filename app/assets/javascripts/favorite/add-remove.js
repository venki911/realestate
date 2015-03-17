$(function(){
  addFavorite()
  removeFavorite()
})

function removeFavorite(){
  $("#remove-favorite").on('click', function(){
    $removeBtn = $(this)
    $addBtn = $("#add-favorite")

    setBtnDisabled($removeBtn)
    setNotification("info", "Processing request")

    var favoriteId = $removeBtn.attr("data-favorite-id")
    var url = "/favorites/" + favoriteId

    $.ajax({
      method: 'DELETE',
      url: url,
      success: function(){
        $removeBtn.hide()
        setBtnEnabled($removeBtn)

        $addBtn.show()
        setNotification("notice", "Property remove from favorite list")
      },
      error: function(){
        setNotification('alert', "Failed to remove favorite list")
        setBtnEnabled($removeBtn)
      }

    })
    return false
  })
}

function addFavorite(){
  $("#add-favorite").on('click', function(){
    $addBtn = $(this)
    $removeBtn = $("#remove-favorite")

    setBtnDisabled($addBtn)

    setNotification("info", "Processing request")
    var propertyId = $addBtn.attr("data-property-id")

    $.ajax({
      method: 'POST',
      url: '/favorites',
      data: {property_id: propertyId},
      success: function(favorite) {
        $addBtn.hide()
        setBtnEnabled($addBtn)

        $removeBtn.attr('data-favorite-id', favorite.id)

        $removeBtn.show()
        setNotification("notice", "Property saved to favorite list")
      },
      error: function(){
        setNotification('alert', "Failed to save this property")
        setBtnEnabled($addBtn)
      }
    })
    return false
  })
}