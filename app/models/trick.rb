class Trick < ActiveRecord::Base
  
  attr_accessible :lead_suit, :leader_index, :round_id
  
  belongs_to :round
  has_many :played_tricks
  has_many :players, :through => :round
  has_many :decks, :through => :round
  
  def trick_winner
    best_card = played_trick.cards.first
    4.times do |i|
      card = played_trick.cards[i]
      best_card = card if card.beats?(best_card)
    end
    winner_index = (card_index(best_card) + leader_index) % 4
    players[winner_index]
  end

  def give_trick_to_winner
    played_trick.update_attributes(:user_id => trick_winner.id)
  end

  def store_trick(played_cards)
    new_played_trick = PlayedTrick.create(:size => 4, :trick_id => id)
    played_cards.each do |card|
      card.card_owner = new_played_trick
      card.save
    end
    new_played_trick.save
  end

  def trick_winner_index
    players.index(trick_winner)
  end

  # private
  def deck
    decks.first
  end
  
  def leader
    players[leader_index]
  end
  
  def size
    round.game.size
  end
  
  def played_trick
    played_tricks.first
  end
  
  def card_index(card)
    played_trick.cards.index(card)
  end
  
end
