class HeartsRound < Round
  
  # shuffle cards
  # deal cards
  
  def pass_cards(direction)
    return if direction == "none"
    cards_to_pass = [ [] , [] , [] , [] ]
    game.size.times do |i|
      3.times do
        cards_to_pass[i] << @players[i].hand[rand(@players[i].hand.length)]
      end
    end
    giving_shift = case direction
    when "left"
      1
    when "across"
      2
    when "right"
      3
    end
    cards_to_pass.each do |set|
      set.each do |card|
        current_player_index = owner_index(card)
        new_player_index = current_player_index + giving_shift
        receiver = players[new_player_index]
        card.card_owner_id = receiver.id
      end
    end
  end
  
  
  # 13.times do
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
  
  def owner_index(card)
    players.index(User.find(self.card_owner_id))
  end
  
end