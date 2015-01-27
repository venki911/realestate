$(function(){
  alertNotification();
})

function alertNotification(){
  $notification = $("#notification")
  if(Config.Flash.key && Config.Flash.value){
    var templateData = Config.Flash
    if(Config.Flash.key == 'notice'){
      templateData.title = "Success"
      templateData.type = 'info'
      templateData.icon = 'ok'
    }
    else{
      templateData.title = "Failure"
      templateData.type = 'danger'
      templateData.icon = 'remove'
    }

    var notificationHtml = tmpl('tmpl-notification', templateData)
    $notification.html(notificationHtml)
    $notification.fadeOut(5000)
  }
  else{
    $notification.hide();
  }
}