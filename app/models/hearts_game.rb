class HeartsGame < Game
  
  def play_game
    until(game_over?)
      new_dealer_seat = get_dealer_seat
      new_round = HeartsRound.create(:game_id => self.id, :dealer_seat => new_dealer_seat)
      new_round.play_round
      check_for_and_set_winner
    end    
  end
  
  def check_for_and_set_winner
    players.each do |player|
      if player.reload.total_score >= 100
        self.winner_id = find_lowest_player_id
        self.save
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
      player.update_attributes(:total_score => 0)
      player.update_attributes(:round_score => 0)
    end
  end
  
end