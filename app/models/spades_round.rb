class SpadesRound < Round
  
  attr_accessor :spades_broken
  has_many :teams, :through => :game
  
  after_initialize :init
  
  def init
    self.spades_broken = false
  end
  
  def play_round
    deal_cards
    make_bids
    13.times do
      new_leader_index = get_leader_index
      new_trick = SpadesTrick.create(:round_id => self.id, :leader_index => new_leader_index)
      new_trick.play_trick
    end
    update_total_scores
    return_cards
    reset_round_values
  end
  
  def make_bids
    teams.each do |team|
      team.bid = 0
      team.players.each do |player|
        player.bid = 1 + rand(3)
        if rand < 0.05
          player.going_nil = true
          player.bid = 0
        end
        team.bid += player.bid
        player.save
        team.save
      end
    end
  end

  def update_total_scores
    update_round_scores
    teams.each do |team|
      # puts team.round_score.inspect
      team.total_score += team.round_score
      team.save
    end
  end
  
  def update_round_scores
    teams.each do |team|
      calculate_team_score(team)
      team.players.each do |player|
        add_player_bonus(player, team)
      end
    end
  end  
  
  # private
  def calculate_team_score(team)
    if met_their_bid?(team)
      team.round_score = 10*team.bid 
      team.bags += team.tricks_won - team.bid
    else
      team.reload.round_score = -10*team.bid
    end
    team.save
  end
  
  def met_their_bid?(team)
    team.tricks_won >= team.bid
  end
  
  def add_player_bonus(player, team)
    if player.going_nil
      team.round_score += (player.played_tricks.empty? ? 100 : -100)
    elsif player.going_blind
      team.round_score += (player.played_tricks.empty? ? 200 : -200)
    end
    team.save
  end  
  
  def game
    SpadesGame.find(self.game_id)
  end
  
  def reset_round_values
    teams.each do |team|
      team.round_score = 0
      team.players.each do |player|
        player.going_nil = false
        player.going_blind = false
        player.save
      end
      team.save
    end
  end
  
  
end