$(function(){
  MemberPropertyForm.init()
})

var MemberPropertyForm = {
  init: function(){
    var _self = this
    _self.handleAutoCalArea()

    _self.handleProvinceChange()
    _self.handleDistrictChange()

    _self.handlePropertyTypeOfChange()
    _self.togglePropertyType()
  },

  handlePropertyTypeOfChange: function(){
    var _self = this
    $("#property_type_of").on('change', function(){
      _self.togglePropertyType()
    })
  },

  togglePropertyType:function(){
    var $title = $(".for-sale-rent")

    var type = $("#property_type_of").val()
    var $forSale = $(".for-sale")
    var $forRent = $(".for-rent")

    if(type == Constant.Property.Sale || type == Constant.Property.Pawn){
      $forSale.show()
      $forRent.hide()
      $title.hide()
    }
    else if (type == Constant.Property.Rent){
      $forRent.show()
      $forSale.hide()
      $title.hide()
    }
    else if (type == Constant.Property.SaleRent){
      $forRent.show()
      $forSale.show()
      $title.show()
    }
  },

  handleAutoCalArea: function() {
    var _self = this
    $("#property_width").on('change', function(){
      _self.updatePropertyArea()
    }).on('keyup', function(){
      _self.updatePropertyArea()
    })

    $("#property_length").on('change', function(){
      _self.updatePropertyArea()
    }).on('keyup',function(){
      _self.updatePropertyArea()
    } )
  },

  updatePropertyArea: function(){
    var w = parseFloat($("#property_width").val())
    var l = parseFloat($("#property_length").val())
    var area = w * l
    area = isNaN(area) ? '' : area
    $("#property_area").val(area)
  },

  handleProvinceChange: function(){
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
  },

  handleDistrictChange: function(){
    $("#property_district_id").on('change', function(){
      $this = $(this)
      var districtId = $this.val()
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
}

