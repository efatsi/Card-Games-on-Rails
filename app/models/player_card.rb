class PlayerCard < ActiveRecord::Base

  SUIT_WEIGHT = Card::SUIT_WEIGHT
  VALUE_WEIGHT = Card::VALUE_WEIGHT

  attr_accessible :player_id, :card_id, :card_passing_set_id

  belongs_to :player
  belongs_to :card
  has_one :played_card, :dependent => :destroy

  validates_presence_of :player_id
  validates_presence_of :card_id

  delegate :suit, :value, :in_english, :suit_weight, :value_weight, :is_a_heart, :is_queen_of_spades, :to => :card
  delegate :hearts_broken, :to => :player


  def is_valid?(lead_suit, is_the_first_trick)
    if player.is_leading?
      is_valid_lead?
    elsif is_the_first_trick
      suit_matches_if_possible(lead_suit) && is_not_a_scoring_card?
    else
      suit_matches_if_possible(lead_suit)
    end
  end

  def has_been_chosen?
    card_passing_set_id.present?
  end

  def can_be_chosen?
    is_not_chosen? &&  player.cards_to_pass.length != 3
  end

  def hand_order
    suit_weight*13 + value_weight   
  end
  
  private
  def is_not_chosen?
    card_passing_set_id.nil?
  end

  def is_valid_lead?
    if suit == "heart"
      hearts_broken || player.only_has?("heart")
    else
      true
    end
  end

  def suit_matches_if_possible(lead_suit)
    suit == lead_suit || player.has_none_of?(lead_suit)
  end

  def is_not_a_scoring_card?
    !is_a_heart && !is_queen_of_spades
  end

end
