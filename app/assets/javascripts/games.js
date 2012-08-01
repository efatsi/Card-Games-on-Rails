$(document).ready(function(){gi
  
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
  reload: function(){
    $.post(window.location.pathname + "/reload", function(html){
      $("#game-page").html(html);
      CardGames.autoplay();
    });
  },
  
  autoplay: function(){
    $.getJSON(window.location.pathname, function(game){
      if (game.isCurrentPlayersTurn){
        CardGames.waitForUserInput();
      }
      else if (game.currentPlayerIsBystander){
        CardGames.waitThenReload
      }
      // if (game.computerShouldPlay){
      //   CardGames.playAsComputer();
      // }
      // else if (game.shouldStartNewRound){
      //   var $newRoundDelay
      //   if (game.isFirstRound) {
      //     $newRoundDelay = 0;
      //   }
      //   else {
      //     $newRoundDelay = 3000;
      //   }
      //   setTimeout(CardGames.startNewRound, $newRoundDelay);
      // }
      // else if (game.shouldStartNewTrick){
      //   var $newTrickDelay
      //   if (game.isFirstTrick) {
      //     $newTrickDelay = 0;
      //   }
      //   else {
      //     $newTrickDelay = 2000;
      //   }
      //   setTimeout(CardGames.startNewTrick, $newTrickDelay);
      // }
      // else if (game.shouldPassCards){
      //   CardGames.passCards();
      // }
    });
  },
  
  waitForUserInput: function(){
    $.post(window.location.pathname, function(html){
      $("#game-page").html(html);
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
  },
  
  waitThenReload: function(){
    setTimeout(CardGames.autoplay, 2000);
  }
}
