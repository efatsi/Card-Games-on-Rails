class SpadesRound < Round
  
  def play_round
    shuffle_cards
    deal_cards
    pass_cards
    13.times do
      new_leader_id = get_leader_id
      new_trick = SpadesTrick.create(:round_id => self.id, :leader_id => new_leader_id)
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
    end
  end

  def update_total_scores
    update_round_scores
    teams.each do |team|
      team.total_score += team.round_score
      team.round_score = 0
    end
  end
  
  def update_round_scores
    teams.each do |team|
      calculate_team_score
    end 
    players.each do |player|
      add_player_bonus(player)
    end
  end  
  
  private
  def calculate_team_score
    if met_their_bid?(team)
      team.round_score += 10*team.bid 
      team.bags += team.tricks_won - team.bid
    else
      team.round_score -= 10*team.bid
    end
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
  end
  
  
end