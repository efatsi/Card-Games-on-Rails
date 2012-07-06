class Trick < ActiveRecord::Base
  
  attr_accessible :lead_suit, :leader_index, :round_id
  
  belongs_to :round
  has_many :played_tricks
  
  def trick_winner
    best_card = trick.cards.first
    4.times do |i|
      card = trick.cards[i]
      best_card = card if card.beats?(best_card)
    end
    leader_index = players.index(leader)
    winner_index = (trick.index(best_card) + leader_index) % 4
    players[winner_index]
  end

  # private
  def leader
    players[leader_index]
  end
  
  def players
    round.game.players
  end
  
  def size
    round.game.size
  end
  
  def trick
    played_tricks.first
  end
  
  def give_trick_to_winner(played_cards)
    trick.player_id = trick_winner.id
    trick.save
  end
  
  def store_trick(played_cards)
    new_played_trick = PlayedTrick.new(:size => 4, :trick_id => id)
    played_cards.each do |card|
      card.card_owner_type = "PlayedTrick"
      card.card_owner_id = new_played_trick.id
      card.save
    end
  end
  
  def trick_winner_index
    players.index(trick_winner)
  end
  
end
