$(document).ready(function(){
  $('form.skip-reload').live("ajax:success", function(event, html){
    CardGames.autoplay();
  });
   
  $('form.immediate-reload').live("ajax:success", function(event, html){
    $("#game-page").html(html);
    CardGames.autoplay();
  });

  $('form.remove-pass-button').live("ajax:success", function(event){
    $("#pass-button").remove();
    CardGames.autoplay();
  });

  $('form.reload-hand').live("ajax:success", function(event, html){
    $("#my-hand").html(html);
  });
  
  $("#toggle-last-trick").live("click", function() {
    $(".last-trick").slideToggle("fast");
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
      else if (game.shouldPassCards){
        CardGames.passCards();
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
  },
  
  passCards: function(){
    $.post(window.location.pathname + "/pass_cards", function(html){
      CardGames.autoplay();
    });
  }
}
