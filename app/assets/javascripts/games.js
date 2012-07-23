$(document).ready(function(){
  $('form.play-card').on("ajax:success", function(event, data){
    $("#my-hand").html(data);
    
  });
});
