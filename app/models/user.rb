class User < ActiveRecord::Base

  include SimplestAuth::Model
  authenticate_by :username
  
  attr_accessible :username, :round_score, :total_score, :bid, :going_blind, :going_nil, :team_id, :game_id, :password, :password_confirmation
  
  belongs_to :team #sometimes
  belongs_to :game #when playing a game
  has_many :played_tricks
  has_many :cards, :as => :card_owner
  
  validates_presence_of :username
  validates_uniqueness_of :username
  validates_presence_of :password, :on => :create
  validates_presence_of :password_confirmation, :on => :create
  validates_confirmation_of :password, :if => :password_required?
    
  def reset_for_new_game
    
  end
  
  def hand
    self.cards(true)
  end
  
end
