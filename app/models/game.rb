class Game < ActiveRecord::Base

  attr_accessible :winner_id

  has_many :players, :dependent => :destroy, :order => "seat ASC"
  has_many :rounds, :dependent => :destroy, :order => "position ASC"
  belongs_to :winner, :class_name => "Player"
  
  def play_game
    until(game_over?)
      new_dealer = get_new_dealer
      new_round = Round.create(:game_id => self.id, :dealer_id => new_dealer.id, :position => next_round_position)
      new_round.play_round
      check_for_and_set_winner
    end    
  end

  def check_for_and_set_winner
    players.each do |player|
      if player.reload.total_score >= 100
        self.update_attributes(:winner_id => find_lowest_player.id)
        return
      end
    end
  end

  def find_lowest_player
    min = 101
    winner = nil
    players.each do |player|
      if player.total_score <= min
        winner = player
        min = player.total_score
      end
    end  
    winner
  end

  def get_new_dealer
    rounds_played == 0 ? player_seated_at(0) : next_dealer
  end
  
  def next_dealer
    old_seat = last_round.dealer.seat
    new_seat = (old_seat + 1) % 4
    player_seated_at(new_seat)
  end

  def rounds_played
    rounds(true).length
  end

  def last_round
    rounds.last
  end

  def next_seat
    self.players(true).length
  end
  
  def next_round_position
    rounds_played
  end

  def is_full?
    players(true).length >= 4
  end

  def game_over?
    winner_id.present?
  end

  def player_seated_at(seat)
    self.players.where("seat = ?", seat).first
  end

end
