class HeartsGame < Game

  # load deck
  
  def play_game
    until(game_over?)
      new_dealer_id = get_dealer_id
      new_round = HeartsRound.create(:game_id => self.id, :dealer_id => new_dealer_id)
      new_round.play_round
      check_for_winner
      winner_id = players.first.id if rounds_played == 100
    end    
  end
  
  def check_for_winner
    players.each do |player|
      if player.total_score >= 100
        winner_id = find_lowest_player_id
        return
      end
    end
  end
  
  def find_lowest_player_id
    min = 101
    winner = nil
    players.each do |player|
      if player.total_score <= min
        winner = player
        min = player.total_score
      end
    end  
    winner.id  
  end
  
  def reset_scores
    players.each do |player|
      player.total_score = 0
    end
  end
  
  private
  
end