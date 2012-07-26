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
        url: window.location.pathname + "/next_player",
        success: function(data){
          console.log(data[0] && data[1]);
          var computer_next = data[0];
          var trick_not_over = data[1];
          if (computer_next && trick_not_over)
          {
            console.log("recognized computer_next and trick_not_over")
            $.post(window.location.pathname + "/play_one_card", function(data) {
              console.log("data now should be a partial")
              $("#game-page").html(data);
            });
          }
          
        }
    });
    
    //  until(@game.next_player.is_human?)
    //    hit controller action (plays a card from a computer)
    //    sleep for a second somehow
    //    $("#game-page").html(data);
    //  end
  });
});