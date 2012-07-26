$(document).ready(function(){
  $('form.game-button').live("ajax:success", function(event, data){
    $("#game-page").html(data);
  });
});


$(document).ready(function(){
  $('form.play-card-button').live("ajax:success", function(event, data){
    $("#game-page").html(data);
    
    $.ajax({
        type: "GET",
        dataType: "json",
        url: window.location.pathname + "/next_player",
        success: function(data){
          console.log(data);
        }
    });
    
    //  until(@game.next_player.is_human?)
    //    hit controller action (plays a card from a computer)
    //    $("#game-page").html(data);
    //  end
  });
});