require 'spec_helper'

describe Game do

  before do
    @game = FactoryGirl.create(:game)
    @user1 = FactoryGirl.create(:user, :username => "game_user1")
    @user2 = FactoryGirl.create(:user, :username => "game_user2")
    @user3 = FactoryGirl.create(:user, :username => "game_user3")
    @user4 = FactoryGirl.create(:user, :username => "game_user4")
  end

  describe "#setup" do

    context "#new_game" do

      it "should show that game has been initiated" do
        @game.should be_an_instance_of Game
      end

      it "should not be over already" do
        @game.is_over?.should == false
      end
    end

    context "#players" do

      it "should know about any players" do
        @player1 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user1.id, :seat => 0)
        @player2 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user2.id, :seat => 1)
        @player3 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user3.id, :seat => 2)
        @player4 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user4.id, :seat => 3)
        @game.players.length.should == 4
      end
    end

  end

  describe "#game_not_full" do

    it "should know if the game is full" do
      @game.is_full?.should == false
      @player1 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user1.id, :seat => 0)
      @player2 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user2.id, :seat => 1)
      @player3 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user3.id, :seat => 2)
      @game.is_full?.should == false
      @player4 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user4.id, :seat => 3)
      @game.is_full?.should == true
    end

    context "next_seat" do

      it "should work with no one in the room" do
        @game.next_seat.should == 0
      end

      it "should work as people enter the room" do
        @player1 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user1.id, :seat => 0)
        @game.next_seat.should == 1
        @player2 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user2.id, :seat => 1)
        @game.next_seat.should == 2
        @player3 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user3.id, :seat => 2)
        @game.next_seat.should == 3
        @player4 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user4.id, :seat => 3)
        @game.next_seat.should == 4
      end
    end

    context "last_round" do

      it "should return nil if no rounds have been played" do
        @game.last_round.should be_nil
      end

      it "should return the correct round with multiple" do
        @round1 = FactoryGirl.create(:round, :game_id => @game.id, :position => @game.next_round_position); @game.reload
        @round2 = FactoryGirl.create(:round, :game_id => @game.id, :position => @game.next_round_position); @game.reload
        @round3 = FactoryGirl.create(:round, :game_id => @game.id, :position => @game.next_round_position); @game.reload
        @game.last_round.should == @round3
      end
    end

  end

  describe "#game_is_full" do

    before do
      @player1 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user1.id, :seat => 0)
      @player2 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user2.id, :seat => 1)
      @player3 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user3.id, :seat => 2)
      @player4 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user4.id, :seat => 3)
    end

    context "get_new_dealer" do

      it "should select the player seated at 0 when no rounds have been played" do
        @game.get_new_dealer.should == @player1
      end

      it "should select the player CCW of the last round's dealer when rounds have been played" do
        @round1 = FactoryGirl.create(:round, :game_id => @game.id, :dealer_id => @player3.id, :position => @game.next_round_position); @game.reload
        @game.get_new_dealer.should == @player4                                                                  
        @round1 = FactoryGirl.create(:round, :game_id => @game.id, :dealer_id => @player4.id, :position => @game.next_round_position); @game.reload
        @game.get_new_dealer.should == @player1
      end
    end

    context "find_lowest_player" do

      it "should work" do
        @player1.update_attributes(:total_score => 10)
        @player2.update_attributes(:total_score => 3)
        @player3.update_attributes(:total_score => 24)
        @player4.update_attributes(:total_score => 5)
        @game.send(:find_lowest_player).should == @player2
      end
    end

    context "check_for_and_set_winner" do

      it "should work if no one has won yet" do
        @player1.update_attributes(:total_score => 10)
        @player2.update_attributes(:total_score => 39)
        @player3.update_attributes(:total_score => 24)
        @player4.update_attributes(:total_score => 24)        
        @game.send(:check_for_and_set_winner)
        @game.is_over?.should == false
      end

      it "should work if some on does win" do
        @player1.update_attributes(:total_score => 120)
        @player2.update_attributes(:total_score => 40)
        @player3.update_attributes(:total_score => 12)
        @player4.update_attributes(:total_score => 120)
        @game.send(:check_for_and_set_winner)
        @game.is_over?.should == true
        @game.winner.should == @player3
      end
    end

    context "already_has?(user)" do

      it "should work for a user/player in the game" do
        @game.already_has?(@user1).should == true
        @game.already_has?(@player1).should == true
      end

      it "should work for a user/player not in the game" do
        @user5 = FactoryGirl.create(:user, :username => "game_user5")
        @player1 = FactoryGirl.create(:player, :game_id => @game.id + 1, :user_id => @user5.id, :seat => 0)
        @game.already_has?(@user5).should == false
      end
    end

    context "get_lead_suit" do

      before do
        @round = FactoryGirl.create(:round, :game_id => @game.id, :dealer_id => @player1.id)
        @trick = FactoryGirl.create(:trick, :round_id => @round.id, :leader_id => @player1.id)
      end

      it "should get the lead_suit" do
        @trick.update_attributes(:lead_suit => "spade")
        @game.get_lead_suit.should == "spade"
      end
    end

    context "is_current_player_next?(player)" do

      before do
        @round = FactoryGirl.create(:round, :game_id => @game.id, :dealer_id => @player1.id)
        @trick = FactoryGirl.create(:trick, :round_id => @round.id, :leader_id => @player1.id)
      end

      it "should know the leader is next at the start" do
        @game.is_current_player_next?(@player1).should == true
      end

      it "should know player 2 is next after player1" do
        create_cards
        @round.deal_cards
        @trick.play_card_from(@player1); @trick.reload
        @game.is_current_player_next?(@player2).should == true
      end
    end

    context "last_trick" do

      before do
        @round = FactoryGirl.create(:round, :game_id => @game.id, :dealer_id => @player1.id)
        @trick = FactoryGirl.create(:trick, :round_id => @round.id, :leader_id => @player1.id)
      end

      it "should know it's last trick" do
        @game.last_trick.should == @trick
        @trick2 = FactoryGirl.create(:trick, :round_id => @round.id, :leader_id => @player2.id)
        @game.last_trick.should == @trick2
      end
    end

    context "played_cards" do

      before do
        @round = FactoryGirl.create(:round, :game_id => @game.id, :dealer_id => @player1.id)
        @trick = FactoryGirl.create(:trick, :round_id => @round.id, :leader_id => @player1.id)
        create_cards
        @round.deal_cards
      end

      it "should know about cards that have been played" do
        @trick.play_card_from(@player1); @trick.reload
        @trick.play_card_from(@player2); @trick.reload
        @game.played_cards.length.should == 2
      end
    end

  end

  describe "#situations" do

    before do
      @player1 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user1.id, :seat => 0)
      @player2 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user2.id, :seat => 1)
      @player3 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user3.id, :seat => 2)
      @player4 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user4.id, :seat => 3)
    end

    context "new_round_time" do

      it "should return true at start without any rounds" do
        @game.new_round_time?.should == true
      end

      it "should return true if rounds exist but last round is over" do
        @round = FactoryGirl.create(:round, :game_id => @game.id, :dealer_id => @player1.id)
        fake_last_round = double("my last round")
        @game.stub(:last_round).and_return(fake_last_round)
        fake_last_round.stub(:is_over?).and_return(true)
        @game.new_round_time?.should == true
      end

      it "should return false if rounds exist and last one is not over" do
        @round = FactoryGirl.create(:round, :game_id => @game.id, :dealer_id => @player1.id)
        @game.new_round_time?.should == false
      end
    end

    context "passing_time" do
      # this is dependent on round...so

      it "should return true if round says so" do
        fake_last_round = double("my last round")
        @game.stub(:last_round).and_return(fake_last_round)
        fake_last_round.stub(:passing_time?).and_return(true)
        @game.passing_time?.should == true
      end

      it "sould return false if round says so" do
        fake_last_round = double("my last round")
        @game.stub(:last_round).and_return(fake_last_round)
        fake_last_round.stub(:passing_time?).and_return(false)
        @game.passing_time?.should == false
      end

      it "should return false if no round exists" do
        @game.passing_time?.should == false
      end
    end

    context "ready_to_pass?" do

      it "should return true if it's passing_time and passing sets are full" do
        @game.stub(:passing_time?).and_return(true)
        @game.stub(:passing_sets_are_full?).and_return(true)
        @game.ready_to_pass?.should == true
      end
    end

    context "new_trick_time?" do
      # dependent on last_round

      it "should return true if round says so" do
        fake_last_round = double("my last round")
        @game.stub(:last_round).and_return(fake_last_round)
        fake_last_round.stub(:is_ready_for_a_new_trick?).and_return(true)
        @game.new_trick_time?.should == true
      end

      it "should return false if round says so" do
        fake_last_round = double("my last round")
        @game.stub(:last_round).and_return(fake_last_round)
        fake_last_round.stub(:is_ready_for_a_new_trick?).and_return(false)
        @game.new_trick_time?.should == false
      end

      it "should return false if no round exists" do
        @game.new_trick_time?.should == false
      end
    end

    context "mid_trick_time?" do
      # dependent on last_round

      it "should return true if round says so" do
        fake_last_round = double("my last round")
        @game.stub(:last_round).and_return(fake_last_round)
        fake_last_round.stub(:has_an_active_trick?).and_return(true)
        @game.mid_trick_time?.should == true
      end

      it "should return false if round says so" do
        fake_last_round = double("my last round")
        @game.stub(:last_round).and_return(fake_last_round)
        fake_last_round.stub(:has_an_active_trick?).and_return(false)
        @game.mid_trick_time?.should == false
      end

      it "should return false if no round exists" do
        @game.mid_trick_time?.should == false
      end
    end

  end 
  
  describe "#methods" do
    
    context "update_scores_if_necessary" do
      
      it "should do round scores if trick is over" do
        fake_last_round = double("my last round")
        @game.stub(:last_round).and_return(fake_last_round)
        fake_last_round.stub(:is_over?).and_return(false)
        
        fake_last_trick = double("my last trick")
        @game.stub(:last_trick).and_return(fake_last_trick)
        fake_last_trick.stub(:is_over?).and_return(true)
        
        fake_last_round.should_receive(:calculate_round_scores)
        fake_last_round.should_not_receive(:update_total_scores)
        @game.should_not_receive(:check_for_and_set_winner)
        
        @game.update_scores_if_necessary
      end
      
      it "should do round and total scores if trick and round is over" do
        fake_last_round = double("my last round")
        @game.stub(:last_round).and_return(fake_last_round)
        fake_last_round.stub(:is_over?).and_return(true)
        
        fake_last_trick = double("my last trick")
        @game.stub(:last_trick).and_return(fake_last_trick)
        fake_last_trick.stub(:is_over?).and_return(true)
        
        fake_last_round.should_receive(:calculate_round_scores)
        fake_last_round.should_receive(:update_total_scores)
        @game.should_receive(:check_for_and_set_winner)
        
        @game.update_scores_if_necessary  
      end
      
      it "shouldn't do anything if nothing is over" do
        fake_last_round = double("my last round")
        @game.stub(:last_round).and_return(fake_last_round)
        fake_last_round.stub(:is_over?).and_return(false)
        
        fake_last_trick = double("my last trick")
        @game.stub(:last_trick).and_return(fake_last_trick)
        fake_last_trick.stub(:is_over?).and_return(false)
        
        fake_last_round.should_not_receive(:calculate_round_scores)
        fake_last_round.should_not_receive(:update_total_scores)
        @game.should_not_receive(:check_for_and_set_winner)
        
        @game.update_scores_if_necessary
      end
    end
    
    context "passing_sets_are_full?" do
      
      before do
        @player1 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user1.id, :seat => 0)
        @player2 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user2.id, :seat => 1)
        @player3 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user3.id, :seat => 2)
        @player4 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user4.id, :seat => 3)
        @round = FactoryGirl.create(:round, :game_id => @game.id, :dealer_id => @player1.id)
        create_cards
        @round.deal_cards
      end
      
      it "should return false if sets have not been filled" do
        @game.send(:passing_sets_are_full?).should == false
      end
      
      it "should return true if sets have been filled" do
        @round.fill_passing_sets
        @game.send(:passing_sets_are_full?).should == true
      end
    end
    
    context "present_usernames" do

      before do
        @player1 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user1.id, :seat => 0)
        @player2 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user2.id, :seat => 1)
        @player3 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user3.id, :seat => 2)
        @player4 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user4.id, :seat => 3)
      end
      
      it "should return the right array of usernames" do
        @game.send(:present_usernames).should == ["game_user1", "game_user2", "game_user3", "game_user4"]
      end
    end
    
  end
  
  describe "#play_game" do

    before do
      @player1 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user1.id, :seat => 0)
      @player2 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user2.id, :seat => 1)
      @player3 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user3.id, :seat => 2)
      @player4 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user4.id, :seat => 3)
      create_cards
    end

    it "should not crash" do
      @game.play_game
    end

  end
end
