class Trick < ActiveRecord::Base
  
  attr_accessible :lead_suit, :leader_seat, :round_id
  
  belongs_to :round
  has_many :played_tricks
  has_many :players, :through => :round
  
  def trick_winner
    best_card = leader.last_played_card
    4.times do |i|
      card = played_trick.reload.cards[i]
      best_card = card if card.beats?(best_card)
    end
    User.find(best_card.was_played_by_id)
  end

  def give_trick_to_winner
    played_trick.update_attributes(:user_id => trick_winner.id)
  end

  def store_trick(played_cards)
    new_played_trick = PlayedTrick.create(:size => 4, :trick_id => id)
    played_cards.each do |card|
      card.card_owner_type = "PlayedTrick" 
      card.card_owner_id = new_played_trick.id
      card.save
    end
    played_cards.each do |card|
      if card.reload.card_owner_id.nil?
        card.update_attributes(:card_owner_id => new_played_trick.id)
      end
    end
  end

  def trick_winner_seat
    trick_winner.seat
  end
  
  def set_memory_attributes(player, card)
    card.update_attributes(:was_played_by_id => player.id)
    player.update_attributes(:last_played_card_id => card.id)
  end
  
  def leader
    seated_at(leader_seat)
  end
  
  def size
    round.game.size
  end
  
  def played_trick
    played_tricks.last
  end
  
  def seated_at(seat)
    self.round.seated_at(seat)
  end
  
end
