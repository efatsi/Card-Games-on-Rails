$(document).ready(function(){
  $(".game-buttons").find(".play-one-card").click(function(data) {
    var $hand = $(".my-hand");
    $.post(window.location.pathname + "/play_one_card", function(data) {
      // alert(data.hand)
      ($hand).html(data.hand);
    });
  });
});