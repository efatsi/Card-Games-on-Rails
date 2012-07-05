class Trick < ActiveRecord::Base
  
  attr_accessible :lead_suit, :leader_id, :round_id
  
  belongs_to :round
  has_many :played_tricks
  
  def trick_winner
    best_card = trick.first
    4.times do |i|
      card = trick[i]
      best_card = card if card.beats?(best_card)
    end
    leader_index = players.index(leader)
    winner_index = (trick.index(best_card) + leader_index) % 4
    players[winner_index]
  end

  private
  def leader
    User.find(leader_id)
  end
  
  def players
    round.game.players
  end
  
  def trick_winner_id
    trick_winner.id
  end
  
  def trick
    played_tricks.first.cards
  end
  
end
