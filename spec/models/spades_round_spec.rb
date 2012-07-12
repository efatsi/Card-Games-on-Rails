require 'spec_helper'

describe SpadesRound do

  before do
    @spades = SpadesGame.create(:size => 4)
    @user1 = FactoryGirl.create(:user, :username => "spades_round_user1", :game_id => @spades.id)
    @user2 = FactoryGirl.create(:user, :username => "spades_round_user2", :game_id => @spades.id)
    @user3 = FactoryGirl.create(:user, :username => "spades_round_user3", :game_id => @spades.id)
    @user4 = FactoryGirl.create(:user, :username => "spades_round_user4", :game_id => @spades.id)
    @team1 = FactoryGirl.create(:team, :game_id => @spades.id)
    @team2 = FactoryGirl.create(:team, :game_id => @spades.id)
    @spades.set_teams
    @spades_round = SpadesRound.create(:game_id => @spades.id, :dealer_index => 0)
    @deck = @spades_round.deck
    @players = @spades_round.players
  end

  describe "#setup" do

    context "new_game" do

      it "should know it is a new spades round" do
        @spades_round.should be_an_instance_of SpadesRound
      end

      it "should know spades have not been broken" do
        @spades_round.spades_broken.should == false
      end        
      
      it "should know about it's Spades Game parent" do
        @spades_round.game.should be_an_instance_of SpadesGame
        @spades_round.game.should == @spades
      end

    end

  end

  describe "#bids" do

    context "make_bids" do

      it "should make bids" do
        @spades_round.make_bids
        @players.each {|p| p.bid.should >= 1 unless p.going_nil == true }
      end

    end

    context "met_there_bid?" do

      before :each do
        13.times do |i|
          trick = PlayedTrick.create(:size => 4)
          4.times do |j|
            card = @deck.cards.first
            card.card_owner = trick
            card.save
          end
          trick.user_id = (i.odd? ? @user1.id : @user2.id)
          trick.save
        end
      end

      it "should work if they met their bid" do
        @team1.update_attributes(:bid => 6)
        @team2.update_attributes(:bid => 7)
        @spades_round.met_their_bid?(@team1).should == true
        @spades_round.met_their_bid?(@team2).should == true
      end

      it "should work if they don't make your bid" do
        @team1.update_attributes(:bid => 8)
        @team2.update_attributes(:bid => 8)
        @spades_round.met_their_bid?(@team1).should == false
        @spades_round.met_their_bid?(@team2).should == false        
      end

    end

  end

  describe "#scoring" do
    
    before :each do
      13.times do |i|
        trick = PlayedTrick.create(:size => 4)
        4.times do |j|
          card = @deck.cards.first
          card.card_owner = trick
          card.save
        end
        trick.user_id = (i.odd? ? @user1.id : @user2.id)
        trick.save
      end
    end
    
    context "both teams hit their bid" do
      
      before :each do
        @team1.update_attributes(:bid => 6)
        @team2.update_attributes(:bid => 7)        
      end
      
      it "calculate team score should work" do
        @spades_round.calculate_team_score(@team1)
        @spades_round.calculate_team_score(@team2)
        @team1.round_score.should == 60
        @team2.round_score.should == 70
      end
      
      it "update_total_score should work" do
        @spades_round.update_total_scores; @team1.reload; @team2.reload
        @team1.total_score.should == 60
        @team2.total_score.should == 70
        @team1.round_score.should == 0
        @team2.round_score.should == 0
      end
      
    end
    
    context "both teams did not make their bid" do
      
      before :each do
        @team1.update_attributes(:bid => 8)
        @team2.update_attributes(:bid => 8)
      end
      
      it "calculate team score should work" do
        @spades_round.calculate_team_score(@team1)
        @spades_round.calculate_team_score(@team2)
        @team1.round_score.should == -80
        @team2.round_score.should == -80
      end

      it "update_total_score should work" do
        @spades_round.update_total_scores; @team1.reload; @team2.reload
        @team1.total_score.should == -80
        @team2.total_score.should == -80
        @team1.round_score.should == 0
        @team2.round_score.should == 0
      end
      
    end
    
    context "both teams overshot their bid" do
      
      before :each do
        @team1.update_attributes(:bid => 5)
        @team2.update_attributes(:bid => 6)
      end
      
      it "calculate team score should work" do
        @spades_round.calculate_team_score(@team1)
        @spades_round.calculate_team_score(@team2)
        @team1.round_score.should == 50
        @team2.round_score.should == 60
        @team1.bags.should == 1
        @team2.bags.should == 1
      end

      it "update_total_score should work" do
        @spades_round.update_total_scores; @team1.reload; @team2.reload
        @team1.total_score.should == 50
        @team2.total_score.should == 60
        @team1.round_score.should == 0
        @team2.round_score.should == 0
      end
      
    end
    
    context "going nil or blind" do
      
      before :each do
        @team1.update_attributes(:bid => 6)
        @team2.update_attributes(:bid => 7)
      end

      it "update round score should work with successful nil hand" do
        @user3.update_attributes(:going_nil => true)
        @spades_round.update_round_scores
        @team1.reload.round_score.should == 160
        @team2.reload.round_score.should == 70
      end

      it "update_total_score should work with successful nil hand" do
        @user3.update_attributes(:going_nil => true)
        @spades_round.update_total_scores; @team1.reload; @team2.reload
        @team1.total_score.should == 160
        @team2.total_score.should == 70
        @team1.round_score.should == 0
        @team2.round_score.should == 0
      end

      it "update round score should work with unsuccessful nil hand" do
        @user1.update_attributes(:going_nil => true)
        @spades_round.update_round_scores
        @team1.reload.round_score.should == -40
        @team2.reload.round_score.should == 70
      end

      it "update_total_score should work with unsuccessful nil hand" do
        @user1.update_attributes(:going_nil => true)
        @spades_round.update_total_scores; @team1.reload; @team2.reload
        @team1.total_score.should == -40
        @team2.total_score.should == 70
        @team1.round_score.should == 0
        @team2.round_score.should == 0
      end

      it "update round score should work with successful blind hand" do
        @user3.update_attributes(:going_blind => true)
        @spades_round.update_round_scores
        @team1.reload.round_score.should == 260
        @team2.reload.round_score.should == 70
      end

      it "update_total_score should work with successful blind hand" do
        @user3.update_attributes(:going_blind => true)
        @spades_round.update_total_scores; @team1.reload; @team2.reload
        @team1.total_score.should == 260
        @team2.total_score.should == 70
        @team1.round_score.should == 0
        @team2.round_score.should == 0
      end

      it "update round score should work with unsuccessul blind hand" do
        @user1.update_attributes(:going_blind => true)
        @spades_round.update_round_scores
        @team1.reload.round_score.should == -140
        @team2.reload.round_score.should == 70
      end

      it "update_total_score should work with unsuccessful blind hand" do
        @user1.update_attributes(:going_blind => true)
        @spades_round.update_total_scores; @team1.reload; @team2.reload
        @team1.total_score.should == -140
        @team2.total_score.should == 70
        @team1.round_score.should == 0
        @team2.round_score.should == 0
      end

    end
    
  end

  describe "#play_round" do
    
    it "should not crash" do
      @spades_round.play_round
    end
  
  end
  
end
