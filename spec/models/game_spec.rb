require 'spec_helper'

describe Game do
  
  before do
    @game = FactoryGirl.create(:game)
    @user1 = FactoryGirl.create(:user, :username => "round_user1")
    @user2 = FactoryGirl.create(:user, :username => "round_user2")
    @user3 = FactoryGirl.create(:user, :username => "round_user3")
    @user4 = FactoryGirl.create(:user, :username => "round_user4")
  end

  describe "#setup" do

    context "#new_game" do

      it "should show that game has been initiated" do
        @game.should be_an_instance_of Game
      end
      
      it "should not be over already" do
        @game.game_over?.should == false
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

  describe "#methods" do
    
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
    
    context "get_new_dealer" do
      
      before do
        @player1 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user1.id, :seat => 0)
        @player2 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user2.id, :seat => 1)
        @player3 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user3.id, :seat => 2)
        @player4 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user4.id, :seat => 3)
      end

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
        @player1 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user1.id, :seat => 0, :total_score => 120)
        @player2 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user2.id, :seat => 1, :total_score => 40)
        @player3 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user3.id, :seat => 2, :total_score => 80)
        @player4 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user4.id, :seat => 3, :total_score => 120)
        @game.find_lowest_player.should == @player2
      end
    end
    
    context "check_for_and_set_winner" do
      
      it "should work if no one has won yet" do
        @player1 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user1.id, :seat => 0, :total_score => 10)
        @player2 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user2.id, :seat => 1, :total_score => 40)
        @player3 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user3.id, :seat => 2, :total_score => 80)
        @player4 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user4.id, :seat => 3, :total_score => 99)        
        @game.check_for_and_set_winner
        @game.game_over?.should == false
      end
      
      it "should work if some on does win" do
        @player1 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user1.id, :seat => 0, :total_score => 120)
        @player2 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user2.id, :seat => 1, :total_score => 40)
        @player3 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user3.id, :seat => 2, :total_score => 12)
        @player4 = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user4.id, :seat => 3, :total_score => 120)
        @game.check_for_and_set_winner
        @game.game_over?.should == true
        @game.winner.should == @player3
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
