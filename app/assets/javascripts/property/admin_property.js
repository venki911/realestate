 $(function(){
    handleRejectStatus()
    handleDefaultStatus()
 })

 function handleRejectStatus(){
   $("#property_verification_status").on('change', function(){
     manageRejectStatus(this)
   })
 }

 function handleDefaultStatus(){
   manageRejectStatus("#property_verification_status")
 }

 function manageRejectStatus(select){
   var rejectStatus = Constant.rejectReason
   var $select = $(select)
   var $crejectReason = $("#c_reject_reason")

   if($select.val() == rejectStatus)
     $crejectReason.show()
   else
     $crejectReason.hide()
 }