class SpadesGame < Game
  
  def play_game
    until(game_over?)
      new_dealer_id = get_dealer_id
      new_round = SpadesRound.create(:game_id => self.id, :dealer_id => new_dealer_id)
      new_round.play_round
      check_for_winner
      winner_id = players.first.id if rounds_played == 100
    end    
  end

  def check_for_winner      
    winning_value = 0
    teams.each do |team|
      if team.total_score >= 500 && team.total_score > winning_value
        winner_id = team.players.first.id
        winning_value = team.total_score
      end
    end
  end

  def reset_scores
    teams.each do |team|
      team.total_score = 0
      team.bid = 0
      team.bags = 0
      team.round_score = 0
      team.total_score = 0
    end
  end

end