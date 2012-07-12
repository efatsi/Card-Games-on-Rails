class HeartsGame < Game
  
  def play_game
    while(!game_over?)
    # 30.times do
      new_dealer_index = get_dealer_index
      new_round = HeartsRound.create(:game_id => self.id, :dealer_index => new_dealer_index)
      new_round.play_round
      check_for_winner
      self.update_attributes(:winner_id => players.first.id)
    end    
  end
  
  def check_for_winner
    players.each do |player|
      if player.total_score >= 100
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