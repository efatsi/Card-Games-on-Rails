$(document).ready(function(){
  $('form.play-card').live("ajax:success", function(event, data){
    $("#game-page").html(data);
  });
  
  $('form.new-trick').live("ajax:success", function(event, data){
    $("#game-page").html(data);
  });  
  
  $('form.new-round').live("ajax:success", function(event, data){
    $("#game-page").html(data);
  });
  
});
