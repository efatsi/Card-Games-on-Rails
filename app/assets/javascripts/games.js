$(document).ready(function(){
  $('form.game-button').live("ajax:success", function(event, data){
    $("#game-page").html(data);
  });
});


$(document).ready(function(){
  $('form.play-card-button').live("ajax:success", function(event, data){
    $("#game-page").html(data);
    autoplay();
  });
});

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
        $.post(window.location.pathname + "/play_one_card", function(data) {
          $("#game-page").html(data);
          autoplay();
        });
      }  
    }
  });
}