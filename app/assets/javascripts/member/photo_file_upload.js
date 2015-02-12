/**
  data.bitrate
*/
$(function(){
  togglePricePerDuration()
  handlePropertyTypeOfChange()
  handleFileUpload()
  handleProvinceChange()
  handleDistrictChange()
  initSortable()
  handleDeleteUploadedPhoto()
  handleAutoCalArea()
});

function reloadSortable(){
  $('.sortable').sortable('reload')
}

function handleAutoCalArea() {
  $("#property_width, #property_length").on('change', function(){
    updatePropertyArea()
  }).on('keypress', function(){
    updatePropertyArea()
  })
}

function updatePropertyArea(){
  var w = parseFloat($("#property_width").val())
  var l = parseFloat($("#property_length").val())
  var area = w * l
  area = isNaN(area) ? '' : area
  $("#property_area").val(area)
}

function initSortable(){
  $(".sortable").sortable({
    placeholder : "<span class='thumbnail'></span>"
  }).bind('sortupdate', function() {

     $sortableContainer = $("#uploaded-images")
     var url = $sortableContainer.attr("data-reposition-url")
     $sortables = $sortableContainer.find("li")

     var photos = $.map($sortables, function(sortable){
       return $(sortable).attr("data-photo-id")
     })

     $.ajax({
      url: url,
      data: {photos: photos},
      dataType: 'json',
      method: 'PUT',
      success: function(){
        setNotification("notice", "Property photo reordered")
      }
     })
  });
}

function handleProvinceChange(){
  $("#property_province_id").on('change', function(){
    $this = $(this)
    var provinceId = $this.val()
    var $district = $("#property_district_id")
    $district.find("option[value!='']").remove()

    var $commune = $("#property_commune_id")
    $commune.find("option[value!='']").remove()

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

function handleDistrictChange(){
  $("#property_district_id").on('change', function(){
    $this = $(this)
    var districtId = $this.val()
    console.log("district changed : ", districtId)
    var $commune = $("#property_commune_id")
    $commune.find("option[value!='']").remove()

    $.ajax({
      url: '/communes.json',
      data: { district_id: districtId },
      method: 'GET',
      success: function(communes){
        $.each(communes, function(index, commune){
          var $option = $("<option value='" + commune.id + "'>" + commune.name + "</option>")
          $commune.append($option)
        })
      }
    })

  })
}

function handleFileUpload(){
  $("#property-photos").fileupload({
    dataType: 'json',
    add: function(e,data) {
      var fileTypes = /(\.|\/)(gif|jpe?g|png)$/i
      file = data.files[0]

      if(fileTypes.test(file.type) || fileTypes.test(file.name)){
        var templateData = {file: file}

        var htmlContent = tmpl('template-upload', templateData)
        data.context = $(htmlContent)
        $("#selected-images").append(data.context)
        readImage(data)

        data.context.find(".upload-image").on('click', function(){
          data.context.find(".progress").css('display','block');
          data.submit();
        })
        data.context.find(".cancel-image").on('click', function(){
          data.context.fadeOut(1000, function(){
            data.context.remove()
          });
        })
    
      }
      else {
        setNotification("alert", file.name + " is not an image file ")
      }
    },
    progress: function(e,data){
      if(data.context){
        var uploaded = Math.ceil(data.loaded / data.total * 100)

        //update progress bar
        var $bar = data.context.find(".progress-bar")
        $bar.css('width', uploaded + "%").attr("aria-valuenow", uploaded).text(uploaded)
      }
    },
    done: function (e, data) {
      data.context.fadeOut(1000, function(){
        data.context.remove()
      });
      addToUploadedImageList(data.result)
      setNotification("notice", "Photo uploaded")
    },
    fail: function(e, data){
      var error = data.jqXHR.responseJSON.error
      setNotification("alert", error)
    }
  });
}


function addToUploadedImageList(uploadImageData){
  var uploadedImageHtml = tmpl('template-uploaded-image', uploadImageData )
  var $uploadedImage = $(uploadedImageHtml).hide()

  $("#uploaded-images").append($uploadedImage)
  $uploadedImage.fadeIn(1000)
  $("#empty-image").remove()

  //New image in sortable so it needs to reload
  reloadSortable()
}

function handlePropertyTypeOfChange(){
  $("#property_type_of").on('change', function(){
    $this = $(this);
    togglePricePerDuration()
  })
}

function togglePricePerDuration(){
  $wrapper = $("#property_price_per_duration_wrapper")
  
  if($("#property_type_of").val() == "Sale")
    $wrapper.hide()
  else
    $wrapper.show();
}

function readImage(data){
  var reader = new FileReader();
  reader.onload = function (e) {
    data.context.find(".img-preview").attr('src', e.target.result);
  }
  reader.readAsDataURL(data.files[0]);
}

function handleDeleteUploadedPhoto(){
  $(document.body).on('click', ".btn-img-removal" ,function(){

    if(!confirm('Are you sure to remove this'))
      return false

    $this = $(this)
    var url = $this.attr("href")

    $.ajax({
      url: url,
      method: 'DELETE',
      success: function(res){
        $list = $this.parent().parent()
        $list.fadeOut(1000, function(){
          $list.remove()
        })
        setNotification("notice", "Photo has been removed")
        reloadSortable()
      },
      error: function(){
        setNotification("alert", "Failed to remove photo")
      }
    })

    return false
  })
}
