$(document).ready(function(){
  $('form.play-card').live("ajax:success", function(event, data){
    // console.log(data);
    $("#game-page").html(data);
  });
});
