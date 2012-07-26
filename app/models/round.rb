class Round < ActiveRecord::Base
  
  PASS_SHIFT = {:left => 1, :across => 2, :right => 3, :none => 0}
  
  attr_accessible :game_id, :dealer_id, :position, :hearts_broken, :cards_have_been_passed
  
  after_create :create_player_rounds_and_card_passing_sets
  after_create :override_card_passing_on_none_rounds
  
  belongs_to :game
  belongs_to :dealer, :class_name => "Player"
  has_many :tricks, :dependent => :destroy, :order => "position ASC"
  has_many :player_rounds
  has_many :card_passing_sets, :through => :player_rounds
  
  validates_presence_of :game_id
  validates_presence_of :dealer_id
  validates_presence_of :position
  
  delegate :players, :player_seated_at, :to => :game
  delegate :leader, :to => :last_trick
  
  def play_round
    deal_cards
    pass_cards
    13.times do
      new_leader = get_new_leader
      new_trick = Trick.create(:round_id => self.id, :leader_id => new_leader.id, :position => next_trick_position)
      new_trick.play_trick
    end
    calculate_round_scores
    update_total_scores
  end
  
  def deal_cards
    new_deck = Card.all
    13.times do
      4.times do |i|
        player = player_seated_at(i)
        random_card = new_deck[rand(new_deck.length)]
        PlayerCard.create(:player_id => player.id, :card_id => random_card.id) 
        new_deck.delete(random_card)
      end
    end    
  end
  
  def pass_cards(direction = pass_direction)
    self.update_attributes(:cards_have_been_passed => true)
    return if direction == :none
    giving_shift = PASS_SHIFT[direction]
    card_passing_sets.each do |set|
      set.player_cards.each do |player_card|
        new_seat = (player_card.player.seat + giving_shift) % 4
        player_card.update_attributes(:player_id => player_seated_at(new_seat).id)
      end
    end
  end
  
  def calculate_round_scores
    player_rounds.each do |p_r| 
      p_r.update_attributes(:round_score => 0)
    end
    tricks(true).each do |trick|
      winner = trick.trick_winner
      p_r = player_round_of(winner)
      p_r.round_score += trick.trick_score
      p_r.save
    end
  end
  
  def update_total_scores
    players.each do |player|
      if player.round_score == 26
        players.each do |p|
          p.total_score += 26 unless p == player
          p.save
        end
      else
        player.total_score += player.round_score
        player.save
      end
    end
  end
  
  def get_new_leader
    tricks_played == 0 ? two_of_clubs_owner : last_trick.trick_winner
  end

  def fill_computer_passing_sets
    card_passing_sets.each do |set|
      if set.player.is_computer?
        (3 - set.player_cards.length).times do |i|
          set.player_cards << set.player.hand[i]
        end
      end
    end
  end
  
  def next_trick_position
    tricks_played
  end
  
  def pass_direction(round_number = position)
    [:left, :across, :right, :none][round_number % 4]
  end

  def tricks_played
    tricks(true).length
  end

  def last_trick
    tricks(true).last
  end
  
  def card_passing_sets
    player_rounds.map(&:card_passing_set)
  end
  
  def passing_time?
    has_not_started_yet? && !cards_have_been_passed && pass_direction != :none
  end

  def has_an_active_trick?
    last_trick.try(:is_not_over?) || false
  end

  def is_ready_for_a_new_trick?
    has_started? && has_no_current_trick? && is_not_over?
  end
  
  def is_over?
    tricks_played == 13 && last_trick.is_over?
  end
  
  def is_not_over?
    !is_over?
  end
  
  private
  def create_player_rounds_and_card_passing_sets
    players.each do |player|
      pr = PlayerRound.create(:player_id => player.id, :round_id => self.id)
      CardPassingSet.create(:player_round_id => pr.id)
    end
  end

  def override_card_passing_on_none_rounds
    self.update_attributes(:cards_have_been_passed => true) if pass_direction == :none
  end
  
  def player_round_of(player)
    player_rounds.where("player_id = ?", player.id).first
  end
  
  def two_of_clubs_owner
    players.each do |player|
      player.hand.each do |card|
        if card.value == "2" && card.suit == "club"
          return player
        end
      end
    end
    nil
  end

  def has_no_current_trick?
    tricks.empty? || last_trick.is_over?
  end

  def has_started?
    !has_not_started_yet?
  end

  def has_not_started_yet?
    tricks.empty? && !cards_have_been_passed
  end
  
end
