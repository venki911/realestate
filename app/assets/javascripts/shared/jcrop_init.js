$(function(){
  initJcrop()
})


function initJcrop(){
  var $cropbox = $("#cropbox")

  $cropbox.Jcrop({
    aspectRatio: 1,
    allowResize: false,
    allowSelect: false,
    setSelect: [0,0,100,100],
    minSize: [100,100],
    maxSize: [100,100],
    onSelect: function(coords){
      update(coords)
    },
    onChange: function(coords){
      update(coords)
    }
  })
}

function update(coords){
  updateForm(coords)
  updatePreview(coords)
}

function updatePreview(coords){
  var $cropbox = $("#cropbox")

  var rx = 100 / coords.w;
  var ry = 100 / coords.h;

  $("#thumb-img-preview").css({
    width: Math.round(rx * $cropbox.width() ) + 'px',
    height: Math.round(ry * $cropbox.height() ) + 'px',
    marginLeft: '-' + Math.round(rx * coords.x) + 'px',
    marginTop: '-' + Math.round(ry * coords.y) + 'px'
  })
}

function updateForm(coords) {
  $("#user_crop_x").val(coords.x)
  $("#user_crop_y").val(coords.y)
  $("#user_crop_w").val(coords.w)
  $("#user_crop_h").val(coords.h)
}

