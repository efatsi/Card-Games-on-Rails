class HeartsRound < Round
  
  attr_accessor :hearts_broken
  after_initialize :init
  
  def init
    self.hearts_broken = false
  end
  
  def play_round
    deal_cards
    pass_cards("left")
    13.times do
      new_leader_seat = get_leader_seat
      new_trick = HeartsTrick.create(:round_id => self.id, :leader_seat => new_leader_seat)
      new_trick.play_trick
    end
    update_total_scores
    return_cards
  end
  
  def pass_cards(direction)
    return if direction == "none"
    cards_to_pass = [ [] , [] , [] , [] ]
    4.times do |i|
      3.times do |j|
        choice = player_seated_at(i).hand[4*j + rand(4)]
        cards_to_pass[i] << choice
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
        current_owner_seat = card.seat_of_owner
        new_owner_seat = (current_owner_seat + giving_shift) % 4
        receiver = player_seated_at(new_owner_seat)
        card.card_owner = receiver
        card.save
      end
    end
  end

  def update_total_scores
    update_round_scores
    players.each do |player|
      if player.round_score == 26
        players.each do |p| 
          p.total_score += 26 unless p == player
          p.save
        end
      else
        player.total_score += player.round_score
        player.save
      end
    end
  end

  def update_round_scores
    players.each do |player|
      player.update_attributes(:round_score => 0)
      player.round_collection.each do |card|
        if card.suit == "heart"
          player.round_score += 1
        elsif card.value == "Q" && card.suit == "spade"
          player.round_score += 13
        end
      end
      player.save
    end
  end

  def game
    HeartsGame.find(self.game_id)
  end
  
end