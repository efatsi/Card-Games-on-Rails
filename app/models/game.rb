class Game < ActiveRecord::Base

  attr_accessible :winner_id, :name

  has_many :players, :dependent => :destroy, :order => "seat ASC"
  has_many :rounds, :dependent => :destroy, :order => "position ASC"
  belongs_to :winner, :class_name => "Player"

  delegate :card_passing_sets, :to => :last_round
  delegate :cards_have_been_passed, :to => :last_round

  def play_game
    until(game_over?)
      new_dealer = get_new_dealer
      new_round = Round.create(:game_id => self.id, :dealer_id => new_dealer.id, :position => next_round_position)
      new_round.play_round
      check_for_and_set_winner
    end    
  end

  def get_new_dealer
    rounds_played == 0 ? player_seated_at(0) : next_dealer
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

  def already_has?(user)
    present_usernames.include?(user.username)
  end

  def last_round
    rounds.last
  end

  def get_lead_suit
    last_trick.try(:lead_suit)
  end

  def is_current_player_next?(player)
    last_trick.try(:is_not_over?) && player == last_trick.try(:next_player)
  end

  def last_trick
    last_round.try(:last_trick)
  end

  def played_cards
    last_trick.try(:played_cards)
  end

  def new_round_time?
    rounds.empty? || last_round.is_over?
  end

  def passing_time?
    last_round.try(:passing_time?)
  end

  def ready_to_pass?
    passing_time? && passing_sets_are_full?
  end

  def new_trick_time?
    last_round.try(:is_ready_for_a_new_trick?)
  end

  def mid_trick_time?
    last_round.try(:has_an_active_trick?)
  end

  def udpate_scores_if_necessary
    if last_rick.is_over?
      last_round.calculate_round_scores
      if last_round.is_over?
        last_round.update_total_scores
        check_for_and_set_winner
      end
    end
  end

  private
  def passing_sets_are_full?
    card_passing_sets.each do |set|
      return false if set.player_cards.length != 3
    end
    true
  end

  def check_for_and_set_winner
    players.each do |player|
      losing_score = (Rails.env == "test" ? 40 : 100)
      if player.reload.total_score >= losing_score
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

  def next_dealer
    old_seat = last_round.dealer.seat
    new_seat = (old_seat + 1) % 4
    player_seated_at(new_seat)
  end

  def rounds_played
    rounds(true).length
  end

  def present_usernames
    players.map(&:username)
  end


end
