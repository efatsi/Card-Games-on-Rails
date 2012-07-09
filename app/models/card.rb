class Card < ActiveRecord::Base

  attr_accessible :suit, :value, :card_owner_type, :card_owner_id, :card_owner

  belongs_to :card_owner, :polymorphic => true

  def beats?(card)
    return false if self.suit != card.suit

    # if it's a face card
    if self.value.to_i == 0
      return true if card.value.to_i != 0

      case self.value
      when "A"
        ["K", "Q", "J"].include?(card.value)
      when "K"
        ["Q", "J"].include?(card.value)
      when "Q"
        ["J"].include?(card.value)
      else
        false
      end

    # if it isn't a face card
    else
      return false if card.value.to_i == 0
      self.value.to_i > card.value.to_i
    end
  end
  
  
  
  def is_valid?(lead_suit, player)
    if self.suit == lead_suit || player.has_none_of?(lead_suit)
      true
    else
      false
    end
  end
  
end
