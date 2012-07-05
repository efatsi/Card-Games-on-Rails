class SpadesTrick < Trick

  def play_trick
    @leader = pick_random_player
    leader_index = @players.index(@leader)
    @size.times do |i|
      player = @players[(leader_index+i)%4]
      if player == @leader
        choice = pick_card(player)
        @lead_suit = choice.suit
      else
        choice = pick_card(player)
      end
      @played << choice
      player.hand.delete(choice)
      @spades_broken = true if (choice.suit == :heart && !@spades_broken)
    end
    recipient = determine_trick_winner(last_trick)
    recipient.round_collection += last_trick
    recipient.team.tricks_won += 1
    @leader = recipient
  end

  def pick_card(player)
    choice = player.hand[rand(player.hand.length)]
    if player == @leader && !player.only_has?(:spade) && !@spades_broken
      player.hand.each do |card|
        choice = card if card.suit != :spade
      end
    else  
      choice = pick_card(player) until choice.is_valid?(@lead_suit, player.hand)
    end
    choice
  end

end