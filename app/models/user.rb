class User < ActiveRecord::Base

  include SimplestAuth::Model
  authenticate_by :username
  
  attr_accessible :username, :round_score, :total_score, :bid, :going_blind, :going_nil, :team_id, :game_id, :password, :password_confirmation, :last_played_card_id, :seat
  
  belongs_to :team #sometimes
  belongs_to :game #when playing a game
  # has_many :user_games  # will add this soon
  has_many :played_tricks
  has_many :cards, :as => :card_owner
  
  validates_presence_of :username
  validates_uniqueness_of :username
  validates_confirmation_of :password, :if => :password_required?
    
  def reset_for_new_game
    self.total_score = 0
    self.round_score = 0
    self.bid = 0
    self.going_nil = false
    self.going_blind = false
    self.save
  end
  
  def hand
    self.cards(true) ## need this for round_spec:two_of_clubs_owner_seat test
  end
  
  def round_collection
    round_collection = []
    self.played_tricks.each do |trick|
      trick.cards.each do |card|
        round_collection << card
      end
    end
    round_collection
  end
  
  def tricks_won
    played_tricks.length
  end
  
  def only_has?(suit)
    self.hand.each do |card|
      return false if card.suit != suit
    end
    true
  end
  
  def has_none_of?(suit)
    self.hand.each do |card|
      return false if card.suit == suit
    end
    true
  end
  
  def last_played_card
    Card.find(last_played_card_id)
  end
  
end
