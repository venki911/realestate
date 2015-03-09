function setBtnDisabled($btn, content){
    var updateContent = content || "Requesting ..."
    var icon = "<i class='glyphicon glyphicon-show'> </i>"
    $btn.disabled = true
    $btn.addClass('disabled')
    $btn.tempContent = $this.html()
    $btn.html(icon + updateContent)
}

function setBtnEnabled($btn){
  $btn.disabled = false
  $btn.removeClass('disabled')
  $btn.html($btn.tempContent)
}