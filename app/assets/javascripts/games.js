$(document).ready(function(){
  $('form.game-button').live("ajax:success", function(event, data){
    $("#game-page").html(data);
  });
});
