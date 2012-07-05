class HeartsGame < Game
  
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

  # load deck
  
  def load_players
    @players = []
    @size.times do
      new_player = Player.new
      @players << new_player unless @players.include?(new_player)
    end
    @dealer = @players[rand(@size)]
  end
  
  # UNTIL GAME_OVER?
  #   GET_OR_CHANGE_DEALER
  #   PLAY A ROUND SOMEHOW
  #   CHECK_FOR_WINNER
  # END
  
  def check_for_winner
    someone_lost = false
    @players.each do |player|
      someone_lost = true if player.total_score >= 100
    end
    if someone_lost
      @winner = find_lowest_player
    end
  end
  
  def find_lowest_player
    min = 101
    winner = nil
    @players.each do |player|
      if player.total_score <= min
        winner = player
        min = player.total_score
      end
    end  
    winner    
  end
  
  def reset_scores
    @players.each do |player|
      player.total_score = 0
    end
  end
  
end