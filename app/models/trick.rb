class Trick < ActiveRecord::Base

  attr_accessible :round_id, :leader_id, :lead_suit, :position

  belongs_to :round
  belongs_to :leader, :class_name => "Player"
  has_many :played_cards, :dependent => :destroy, :order => "position ASC"

  validates_presence_of :round_id
  validates_presence_of :leader_id
  validates_presence_of :position

  delegate :players, :to => :round

  def play_trick
    players.each do |player|
      get_card_from(player)
    end
  end

  def get_card_from(player)
    player_card = player.select_random_card
    card_position = self.next_position
    PlayedCard.create(:player_card_id => player_card.id, :trick_id => self.id, :position => card_position)
    self.update_attributes(:lead_suit => player_card.suit) if card_position == 0
  end

  def next_position
    self.played_cards.length
  end

  def trick_winner
    winning_card.player
  end

  def winning_card
    best_card = played_cards.first
    played_cards.each do |played_card|
      best_card = played_card if played_card.beats?(best_card)
    end
    best_card
  end

  def trick_score
    score = 0
    played_cards.each do |played_card|
      if played_card.is_a_heart
        score += 1
      elsif played_card.is_queen_of_spades
        score += 13
      end
    end  
    score
  end

end