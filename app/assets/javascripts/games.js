$(document).ready(function(){
  $('form.play-card').on("ajax:success", function(event, data){
    // console.log(data);
    $("#game-page").html(data);
  });
});
