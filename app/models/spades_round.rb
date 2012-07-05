class SpadesRound < Round
  
  # shuffle cards
  # deal cards
  
  def make_bids
    @players.each do |p|
      p.bid = 1 + rand(3)
      if rand < 0.01
        p.going_nil = true
        p.bid = 0
      end
      p.team.bid += p.bid
    end
  end

  13.times do
    new_leader_id = get_leader_id
    new_trick = SpadesTrick.create(:round_id => self.id, :leader_id => new_leader_id)
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
      if team.tricks_won > team.bid
        team.round_score += 10*team.bid
        team.bags += team.tricks_won - team.bid
      elsif team.tricks_won == team.bid
        team.round_score += 10*team.bid 
      else
        team.round_score -= 10*team.bid
      end
    end 
    @players.each do |player|
      if player.going_nil
        player.team.round_score += (player.round_collection.empty? ? 100 : -100)
      end
      if player.going_blind
        player.team.round_score += (player.round_collection.empty? ? 200 : -200)
      end
    end
  end
  
  # return cards 
  
  
end