$(document).ready(function(){
  $(".game-buttons").find(".play-one-card").click(function(data) {
    var $hand = $(".my-hand");
    $.post(window.location.pathname + "/play_one_card", function(data){
      ($hand).html(data);
    });
  });
});

$("#comment-notice").html('<div class="flash notice"><%= escape_javascript(flash.delete(:notice)) %></div>');



