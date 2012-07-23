class Round < ActiveRecord::Base
  
  PASS_SHIFT = {:left => 1, :across => 2, :right => 3, :none => 0}
  
  attr_accessible :game_id, :dealer_id, :position
  attr_accessor :hearts_broken
  
  after_create :create_player_rounds_and_cards_to_pass
  
  belongs_to :game
  belongs_to :dealer, :class_name => "Player"
  has_many :tricks, :dependent => :destroy, :order => "position ASC"
  has_many :player_rounds
  
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
    # print players.map{|p| p.reload.total_score}.inspect
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
  
  def pass_cards(direction = direction_for_round(position))
    return if direction == :none
    cards_to_pass = collect_cards_to_pass
    do_the_passing(cards_to_pass, direction)
  end
  
  def collect_cards_to_pass
    cards_to_pass = [ [] , [] , [] , [] ]
    players.each do |player|
      cards_to_pass[player.seat] = player.choose_cards_to_pass
    end
    cards_to_pass
  end
  
  def do_the_passing(cards_to_pass, direction)
    giving_shift = PASS_SHIFT[direction]
    cards_to_pass.each do |set|
      set.each do |player_card|
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
  
  def tricks_played
    tricks(true).length
  end
  
  def last_trick
    tricks(true).last
  end
  
  def player_round_of(player)
    player_rounds.where("player_id = ?", player.id).first
  end
  
  def direction_for_round(position)
    [:left, :across, :right, :none][position % 4]
  end
  
  def create_player_rounds_and_cards_to_pass
    players.each do |player|
      pr = PlayerRound.create(:player_id => player.id, :round_id => self.id)
      CardsToPass.create(:player_round_id => pr.id)
    end
  end
  
  def next_trick_position
    tricks_played
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
      
  
end
