class User < ActiveRecord::Base

  include SimplestAuth::Model
  authenticate_by :username
  
  attr_accessible :username, :password, :password_confirmation
  
  has_many :players, :dependent => :destroy, :order => "created_at ASC"
  
  validates_presence_of :username
  validates_uniqueness_of :username
  validates_confirmation_of :password, :if => :password_required?

  delegate :hand, :to => :current_player
  
  def current_player_in_game(game)
    players.where("game_id = ?", game).first
  end
  
  def is_playing_in?(game)
    current_player = current_player_in_game(game)
    current_player.present? && current_player.game_id == game.id
  end
  
end
