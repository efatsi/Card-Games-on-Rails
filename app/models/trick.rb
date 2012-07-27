class Trick < ActiveRecord::Base

  attr_accessible :round_id, :leader_id, :lead_suit, :position

  after_create :start_with_two_of_clubs, :if => :trick_is_first?

  belongs_to :round
  belongs_to :leader, :class_name => "Player"
  has_many :played_cards, :dependent => :destroy, :order => "position ASC"

  validates_presence_of :round_id
  validates_presence_of :leader_id
  validates_presence_of :position

  delegate :players, :player_seated_at, :to => :round

  def play_trick
    players_in_order.each do |player|
      play_card_from(player)
    end
  end

  def play_card_from(player, card = nil)
    card ||= player.choose_card(lead_suit, trick_is_first?)
    card_position = next_position
    PlayedCard.create(:player_card_id => card.id, :trick_id => self.id, :position => card_position)
    self.update_attributes(:lead_suit => card.suit) if player == leader
    round.hearts_broken = true if card.suit == "heart"
    round.save
  end

  def next_player
    player_seated_at((leader.seat + next_position) % 4)
  end

  def trick_winner
    winning_card.player
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

  def cards_played
    self.played_cards.length
  end

  def is_over?
    cards_played == 4
  end

  def is_not_over?
    cards_played < 4
  end
  
  def display_trick_info
    if is_over?
      "Trick was lead by #{leader.username} and won by #{trick_winner.username}.
      The lead suit was #{lead_suit.pluralize}"
    else
      "Trick is lead by #{leader.username}, it is #{next_player.username}'s turn."
    end
  end

  private
  def players_in_order
    in_order = []
    4.times do |i|
      in_order << player_seated_at((leader.seat + i) % 4)
    end
    in_order
  end  

  def next_position
    self.played_cards(true).length
  end

  def winning_card
    best_card = played_cards.first
    played_cards.each do |played_card|
      best_card = played_card if played_card.beats?(best_card)
    end
    best_card
  end
  
  def start_with_two_of_clubs
    play_card_from(leader, leader.two_of_clubs)
  end

  def trick_is_first?
    position == 0 && Rails.env != "test"
  end

end