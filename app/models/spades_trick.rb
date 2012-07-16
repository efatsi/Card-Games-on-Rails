class SpadesTrick < Trick
  
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
      set_memory_attributes(player, choice)
      played_cards << choice
      player.hand.delete(choice)
      round.spades_broken = true if (choice.suit == "spade" && !spades_broken)
    end
    store_trick(played_cards)
    give_trick_to_winner
  end
  
  def pick_card(player)
    choice = player.hand[rand(player.hand.length)]
    if player == leader && !player.only_has?("spade") && !spades_broken
      player.hand.each do |card|
        choice = card if card.suit != "spade"
      end
    else  
      choice = pick_card(player) until choice.is_valid?(lead_suit, player)
    end
    choice
  end  
  
  def spades_broken
    round.spades_broken
  end

  def round
    SpadesRound.find(self.round_id)
  end
  
end