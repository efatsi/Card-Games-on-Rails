class HeartsRound < Round
  
  # shuffle cards
  # deal cards
  
  def pass_cards(direction)
    return if direction == "none"
    cards_to_pass = [ [] , [] , [] , [] ]
    4.times do |i|
      3.times do
        cards_to_pass[i] << @players[i].hand[rand(@players[i].hand.length)]
      end
    end
    take_from_shift = case direction
    when "left"
      3
    when "across"
      2
    when "right"
      1
    end
    4.times do |i|
      @players[i].hand += cards_to_pass[(i + take_from_shift) % 4]
    end
  end
  
  
  # 13.times od
  #   GET_OR_CHANGE_LEADER
  #   PLAY A TRICK SOMEHOW
  # end
  
  
  def update_total_scores
    update_round_scores
    @players.each do |player|
      if player.round_score == 26
        @players.each { |p| p.total_score += 26 unless p == player }
      else
        player.total_score += player.round_score
      end
    end
  end
  
  # return cards
  
  private
  def two_of_clubs_owner
    @players.each do |player|
      player.hand.each do |card|
        if card.suit == :club && card.value = "2"
          return player
        end
      end
    end
  end
  
  def update_round_scores
    @players.each do |player|
      player.round_score = 0
      player.round_collection.each do |card|
        if card.suit == :heart
          player.round_score += 1
        elsif card.value == "Q" && card.suit == :spade
          player.round_score += 13
        end
      end  
    end
  end
  
end