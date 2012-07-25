require 'spec_helper'

describe Round do

  before do
    @game = FactoryGirl.create(:game)
    @user1 = FactoryGirl.create(:user, :username => "round_user1")
    @user2 = FactoryGirl.create(:user, :username => "round_user2")
    @user3 = FactoryGirl.create(:user, :username => "round_user3")
    @user4 = FactoryGirl.create(:user, :username => "round_user4")
    @player1 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user1.id, :seat => 0)
    @player2 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user2.id, :seat => 1)
    @player3 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user3.id, :seat => 2)
    @player4 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user4.id, :seat => 3)
    @round = FactoryGirl.create(:round, :game_id => @game.id, :dealer_id => @player1.id)
  end

  describe "#setup" do

    context "#new_round" do

      it "should show that round has been initiated" do
        @round.should be_an_instance_of Round
      end

      it "should know it's game parent" do
        @round.game.should == @game
      end

      it "should know it's player" do
        @round.players.length.should == 4
        @round.players.include?(@player1).should == true
      end

      it "should know who the dealer is" do
        @round.dealer.should == @player1
      end
      
      it "should know that hearts haven't been broken yet" do
        @round.hearts_broken.should == false
      end
      
    end

  end

  describe "#methods" do

    context "deal_cards" do
      
      before do        
        create_cards
      end
      
      it "should deal 13 cards to every player" do
        @round.deal_cards
        @round.players.each do |player|
          player.hand.length.should == 13
        end
      end
    end
    
    context "pass_cards" do
      
      before do
        create_cards
        @round.deal_cards
        @round.fill_passing_sets
      end
      
      it "should not crash" do
        @round.pass_cards(:left)
      end
      
      it "should pass 3 cards to the left" do
        current_1_hand = [] + @player1.hand
        current_2_hand = [] + @player2.hand
        @round.pass_cards(:left)
        new_cards = 0
        @player2.reload.hand.each do |card|
          if !current_2_hand.include?(card)
            new_cards += 1
            current_1_hand.should include(card)
          end
        end
        new_cards.should == 3
      end
      
      it "should pass 3 cards to the right" do
        current_1_hand = [] + @player1.hand
        current_4_hand = [] + @player4.hand
        @round.pass_cards(:right)
        new_cards = 0
        @player4.reload.hand.each do |card|
          if !current_4_hand.include?(card)
            new_cards += 1
            current_1_hand.should include(card)
          end
        end
        new_cards.should == 3
      end
        
      it "should pass 3 cards across" do
        current_1_hand = [] + @player1.hand
        current_3_hand = [] + @player3.hand
        @round.pass_cards(:across)
        new_cards = 0
        @player3.reload.hand.each do |card|
          if !current_3_hand.include?(card)
            new_cards += 1
            current_1_hand.should include(card)
          end
        end
        new_cards.should == 3
      end
      
      it "should not pass any cards for none" do
        current_1_hand = [] + @player1.hand
        @round.pass_cards(:none)
        new_cards = 0
        @player1.reload.hand.each do |card|
          new_cards += 1 unless current_1_hand.include?(card)
        end
        new_cards.should == 0
      end
    end
    
    context "two_of_clubs_owner" do
      
      it "should correctly find a Player" do
        create_cards
        @round.deal_cards
        @round.send(:two_of_clubs_owner).should be_an_instance_of Player
      end
      
      it "should find the correct Player" do
        two_club = Card.create(:value => "2", :suit => "club")
        pc = PlayerCard.create(:player_id => @player1.id, :card_id => two_club.id)
        @round.send(:two_of_clubs_owner).should == @player1
        pc.update_attributes(:player_id => @player2.id)
        @round.send(:two_of_clubs_owner).should == @player2
      end      
    end
    
    context "get_new_leader" do
      
      it "should find the two of clubs owner without any tricks played" do
        two_club = Card.create(:value => "2", :suit => "club")
        pc = PlayerCard.create(:player_id => @player1.id, :card_id => two_club.id)
        @round.get_new_leader.should == @player1
      end
      
      it "should find last trick winner when trick(s) have been played" do
        first_trick = double("my first trick")
        trick = double("my trick")
        trick.stub(:trick_winner).and_return(@player4)
        @round.stub(:tricks).and_return([first_trick, trick])
        @round.get_new_leader.should == @player4
      end
    end
    
    context "pass_direction(position)" do
      
      it "should return :left for positions 0, 4, 8" do
        @round.pass_direction(0).should == :left
        @round.pass_direction(4).should == :left
        @round.pass_direction(8).should == :left
      end
      
      it "should return :across for positions 1, 5 ,9" do
        @round.pass_direction(1).should == :across
        @round.pass_direction(5).should == :across
        @round.pass_direction(9).should == :across
      end
      
      it "should return :right for positions 2, 6, 10" do
        @round.pass_direction(2).should == :right
        @round.pass_direction(6).should == :right
        @round.pass_direction(10).should == :right
      end
      
      it "should return :none for positions 3, 7, 11" do
        @round.pass_direction(3).should == :none
        @round.pass_direction(7).should == :none
        @round.pass_direction(11).should == :none
      end
    end
  
  end
  
  describe "#round_play" do
      
    context "making new tricks" do
      
      before do
        create_cards
        @round.deal_cards
      end
      
      it "should increment trick count of the round" do
        expect{ Trick.create(:round_id => @round.id, :leader_id => @player1.id, :position => 0) }.to change{ @round.tricks(true).length }.by(1)
      end
      
      it "should assign appropriate position to a new trick" do
        trick1 = Trick.create(:round_id => @round.id, :leader_id => @player1.id, :position => @round.tricks_played); @round.reload
        trick2 = Trick.create(:round_id => @round.id, :leader_id => @player1.id, :position => @round.tricks_played); @round.reload
        trick3 = Trick.create(:round_id => @round.id, :leader_id => @player1.id, :position => @round.tricks_played); @round.reload
        trick1.position.should == 0
        trick2.position.should == 1
        trick3.position.should == 2
      end
    end
    
  end
  
  describe "#round_scoring" do
    
    context "shared_round" do
      
      before do
        @pr1 = FactoryGirl.create(:player_round, :player_id => @player1.id, :round_id => @round.id)
        @pr2 = FactoryGirl.create(:player_round, :player_id => @player2.id, :round_id => @round.id)
        @pr3 = FactoryGirl.create(:player_round, :player_id => @player3.id, :round_id => @round.id)
        @pr4 = FactoryGirl.create(:player_round, :player_id => @player4.id, :round_id => @round.id)
        
        first_trick = double("first trick")
        second_trick = double("second trick")
        third_trick = double("third trick")
        fourth_trick = double("fourth trick")
        
        first_trick.stub(:trick_winner).and_return(@player1)
        second_trick.stub(:trick_winner).and_return(@player2)
        third_trick.stub(:trick_winner).and_return(@player3)
        fourth_trick.stub(:trick_winner).and_return(@player4)
        
        first_trick.stub(:trick_score).and_return(10)
        second_trick.stub(:trick_score).and_return(3)
        third_trick.stub(:trick_score).and_return(10)
        fourth_trick.stub(:trick_score).and_return(3)
        
        @round.stub(:tricks).and_return([first_trick, second_trick, third_trick, fourth_trick])
      end
      
      it "should calculate round score to total 26" do
        @round.calculate_round_scores
        all_round_scores = 0
        @round.player_rounds.each {|pr| all_round_scores += pr.reload.round_score }
        all_round_scores.should == 26
      end
    end
    
  end
  
  describe "#total_scoring" do
    
    context "during a regular round" do
      
      before do
        @pr1 = FactoryGirl.create(:player_round, :player_id => @player1.id, :round_id => @round.id, :round_score => 3)
        @pr2 = FactoryGirl.create(:player_round, :player_id => @player2.id, :round_id => @round.id, :round_score => 6)
        @pr3 = FactoryGirl.create(:player_round, :player_id => @player3.id, :round_id => @round.id, :round_score => 10)
        @pr4 = FactoryGirl.create(:player_round, :player_id => @player4.id, :round_id => @round.id, :round_score => 7)
      end
      
      it "should update players total_scores appropriately" do
        @round.update_total_scores
        @player1.reload.total_score.should == 3
        @player2.reload.total_score.should == 6
        @player3.reload.total_score.should == 10
        @player4.reload.total_score.should == 7
      end
    end
    
    context "during a swept round" do
      
      before do
        @pr1 = FactoryGirl.create(:player_round, :player_id => @player1.id, :round_id => @round.id, :round_score => 0)
        @pr2 = FactoryGirl.create(:player_round, :player_id => @player2.id, :round_id => @round.id, :round_score => 26)
        @pr3 = FactoryGirl.create(:player_round, :player_id => @player3.id, :round_id => @round.id, :round_score => 0)
        @pr4 = FactoryGirl.create(:player_round, :player_id => @player4.id, :round_id => @round.id, :round_score => 0)
      end
      
      it "should acknowledge the moon shooting" do
        @round.update_total_scores
        @player1.reload.total_score.should == 26
        @player2.reload.total_score.should == 0
        @player3.reload.total_score.should == 26
        @player4.reload.total_score.should == 26
      end
    end
  end
  
  describe "#play_round" do
    
    before do
      create_cards
    end
    
    it "should not crash" do
      @round.play_round
    end
    
  end
end