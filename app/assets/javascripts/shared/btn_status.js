var BtnToggle = function(action1, action2)

function setBtnDisabled($btn, content){
    var updateContent = content || "Requesting ..."
    var icon = "<i class='glyphicon glyphicon-eye-open'> </i>"
    $btn.disabled = true
    $btn.addClass('disabled')
    $btn.tempContent = $this.html()
    $btn.html(icon + updateContent)
}

function setBtnEnabled($btn, content){
  var updateContent = content || $btn.tempContent
  $btn.disabled = false
  $btn.removeClass('disabled')
  $btn.html(updateContent)
}