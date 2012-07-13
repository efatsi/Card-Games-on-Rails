class HeartsTrick < Trick
  
  def play_trick
    played_cards = []
    4.times do |i|
      player = players[(leader_index+i)%4]
      if player == leader
        choice = pick_card(player)
        self.update_attributes(:lead_suit => choice.suit)
      else
        choice = pick_card(player)
      end
      played_cards << choice
      choice.was_played_by_id = player.id
      player.hand.delete(choice)
      round.hearts_broken = true if (choice.suit == "heart" && !hearts_broken)
    end
    store_trick(played_cards)
    give_trick_to_winner
  end
  
  def pick_card(player)
    choice = player.hand[rand(player.hand.length)]
    if player == leader && !player.only_has?("heart") && !hearts_broken
      player.hand.each do |card|
        choice = card if card.suit != "heart"
      end
    else  
      choice = pick_card(player) until choice.is_valid?(lead_suit, player)
    end
    choice
  end  
  
  def hearts_broken
    round.hearts_broken
  end

  def round
    HeartsRound.find(self.round_id)
  end
  
end