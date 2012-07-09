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
    end
    update_total_scores
    return_cards
  end
  
  def make_bids
    players.each do |p|
      p.bid = 1 + rand(3)
      if rand < 0.01
        p.going_nil = true
        p.bid = 0
      end
      p.team.bid += p.bid
      p.save
    end
  end

  def update_total_scores
    update_round_scores
    teams.reload.each do |team|
      team.total_score += team.round_score
      team.round_score = 0
      team.save
    end
  end
  
  def update_round_scores
    teams.each do |team|
      calculate_team_score(team)
    end 
    players.each do |player|
      add_player_bonus(player)
    end
  end  
  
  # private
  def calculate_team_score(team)
    if met_their_bid?(team)
      team.round_score += 10*team.bid 
      team.bags += team.tricks_won - team.bid
    else
      team.round_score -= 10*team.bid
    end
    team.save
  end
  
  def met_their_bid?(team)
    team.tricks_won >= team.bid
  end
  
  def add_player_bonus(player)
    if player.going_nil
      player.team.round_score += (player.played_tricks.empty? ? 100 : -100)
    elsif player.going_blind
      player.team.round_score += (player.played_tricks.empty? ? 200 : -200)
    end
    player.team.save
  end  
  
  def game
    SpadesGame.find(self.game_id)
  end
  
  
end