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
});

function reloadSortable(){
  $('.sortable').sortable('reload')
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
        $district.selectpicker('refresh')
        $commune.selectpicker('refresh')
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
        $commune.selectpicker('refresh')
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
    
      }
      else {
        alert(file.name + " is not an image file ")
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

    progressall: function (e, data) {

    },
    done: function (e, data) {
      data.context.fadeOut(1000, function(){
        data.context.remove()
      });
      addToUploadedImageList(data.result)

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
  $(".btn-img-removal").on('click', function(){
    $this = $(this);
    if(!confirm('Are you sure to remove this'))
      return false

    return false
  })
}
