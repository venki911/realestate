$(function(){
  initSearch()
  handleSearchProvinceChange()
  clearForm();
})

function initSearch(){
  $("#p-search-group button").on('click', function(){
    var $this = $(this)
    $("#p-search-group button").removeClass("active")
    $this.addClass("active")
    var elm = $this.attr("data-elm")
    var val = $this.attr("data-value")
    $(elm).val(val)

  })
}

function clearForm(){
  $(".btn-clear").on('click', function(){
    $(".form-search")[0].reset();
    return false;
  })
}

function handleSearchProvinceChange(){
  $("#search_province_id").on('change', function(){
    $this = $(this)
    var provinceId = $this.val()
    var $district = $("#search_district_id")
    $district.find("option[value!='']").remove()

    $.ajax({
      url: '/districts.json',
      data: { province_id: provinceId },
      method: 'GET',
      success: function(districts){
        $.each(districts, function(index, district){
          var $option = $("<option value='" + district.id + "'>" + district.name + "</option>")
          $district.append($option)
        })
      }
    })
  })
}