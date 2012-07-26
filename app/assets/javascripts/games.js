$(document).ready(function(){
  $('form.game-button').live("ajax:success", function(event, data){
    $("#game-page").html(data);
  });
});


$(document).ready(function(){
  $('form.play-card-button').live("ajax:success", function(event, data){
    $("#game-page").html(data);
    
    function autoplay()
    {
      $.ajax({
        type: "GET",
        url: window.location.pathname + "/next_player",
        success: function(data){
          var computer_next = data[0];
          var trick_not_over = data[1];
          if (computer_next && trick_not_over)
          {
            console.log("recognized computer_next and trick_not_over")
            $.post(window.location.pathname + "/play_one_card", function(data) {
              console.log("should load a partial, then call itself again")
              $("#game-page").html(data);
              autoplay();
            });
          }  
        }
      });
    }
    
    autoplay();
    
    //  until(@game.next_player.is_human?)
    //    hit controller action (plays a card from a computer)
    //    sleep for a second somehow
    //    $("#game-page").html(data);
    //  end
  });
});