class SpadesGame < Game
  
    def load_players
      @players = []
      @size.times do
        new_player = Player.new
        @players << new_player unless @players.include?(new_player)
      end
      @team_1 = Team.new(@players[0], @players[2])
      @team_2 = Team.new(@players[1], @players[3])
      @players[0].team = @team_1
      @players[1].team = @team_2
      @players[2].team = @team_1
      @players[3].team = @team_2
      @dealer = @players[rand(@size)]
    end
    
    def play_game
      load_deck
      load_players
      until(game_over?)
        get_or_change_dealer
        play_round
        check_for_winner
        @winner = @players.first if @rounds_played == 100
      end    
    end
    
    
    # UNTIL GAME_OVER?
    #   GET_OR_CHANGE_DEALER
    #   PLAY A ROUND SOMEHOW
    #   CHECK_FOR_WINNER
    # END
    
    
    def check_for_winner      
      winning_value = 0
      teams.each do |team|
        if team.total_score >= 500 && team.total_score > winning_value
          @winner = team
          winning_value = team.total_score
        end
      end
    end
    
    def reset_scores
      teams.each do |team|
        team.total_score = 0
        team.bid = 0
        team.tricks_won = 0
        team.round_score = 0
        team.total_score = 0
      end
    end
  
end