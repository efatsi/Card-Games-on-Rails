$(document).ready(function(){
  $('form.game-button').live("ajax:success", function(event, html){
    $("#game-page").html(html);
  });
   
  $('form.play-card-button').live("ajax:success", function(event, html){
    $("#game-page").html(html);
    CardGames.autoplay();
  });
});

CardGames = {
  autoplay: function(){
    $.getJSON(window.location.pathname + "/get_game_info", function(game){
      if (game.hasActiveTrick && game.nextPlayerIsComputer){
        CardGames.playAsComputer();
      }
      else if (game.shouldStartNewRound){
        CardGames.startNewRound();
      }
      else if (game.shouldStartNewTrick){
        CardGames.startNewTrick();
      }
    });
  },
  
  playAsComputer: function(){
    $.post(window.location.pathname + "/play_one_card", function(html){
      $("#game-page").html(html);
      CardGames.autoplay();
    });
  },

  startNewRound: function(){
    $.post(window.location.pathname + "/new_round", function(html){
      $("#game-page").html(html);
      CardGames.autoplay();
    });
  },

  startNewTrick: function(){
    $.post(window.location.pathname + "/new_trick", function(html){
      $("#game-page").html(html);
      CardGames.autoplay();
    });
  }
}
