class Player < ActiveRecord::Base
  
  attr_accessible :game_id, :user_id, :seat, :total_score
  
  belongs_to :game
  belongs_to :user
  has_many :player_cards
  has_many :cards, :through => :player_cards
  has_many :played_cards, :through => :player_cards
  has_many :player_rounds, :order => "created_at ASC"
  
  validates_presence_of :game_id
  validates_presence_of :user_id
  validates_presence_of :seat
  validates_presence_of :total_score
  
  delegate :username, :to => :user
  delegate :round_score, :to => :last_player_round
  delegate :hearts_broken, :to => :last_player_round
  delegate :leader, :to => :last_player_round
  delegate :card_passing_set, :to => :last_player_round
  
  def hand
    collection = self.reload.player_cards(true).joins("LEFT JOIN played_cards ON played_cards.player_card_id = player_cards.id").where("played_cards.id IS NULL").readonly(false)
    collection.sort{|a,b| a.hand_order <=> b.hand_order }
  end
  
  def choose_card(lead_suit)
    hand.shuffle.each {|c| return c if c.is_valid?(lead_suit) }
  end

  def has_none_of?(suit)
    self.hand.each do |card|
      return false if card.suit == suit
    end
    true
  end
  
  def only_has?(suit)
    self.hand.each do |card|
      return false if card.suit != suit
    end
    true
  end
  
  def last_player_round
    player_rounds.last
  end
  
  def two_of_clubs
    player_cards.each do |card|
      return card if (card.value == "2" && card.suit == "club")
    end
    nil
  end
  
  def is_leading?
    self == leader
  end
  
  def cards_to_pass
    card_passing_set.player_cards
  end
  
  
end
