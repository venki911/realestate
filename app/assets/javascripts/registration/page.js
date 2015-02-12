$(function(){
  handleAgreeTerm()
  updateSupportBtn()
})

function handleAgreeTerm(){
  $("#agree-term").on('change', function(){
    updateSupportBtn()
  })
}

function updateSupportBtn(){
  if($("#agree-term").length > 0){
    var checkbox = $("#agree-term").get(0)
    if(checkbox.checked)
      $("#btn-registration").removeClass("disabled")
    else
      $("#btn-registration").addClass("disabled")
  }
}