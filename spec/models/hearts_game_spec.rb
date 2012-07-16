require 'spec_helper'

describe HeartsGame do

  before :each do
    @hearts = HeartsGame.create(:size => 4)
    @user1 = FactoryGirl.create(:user, :game_id => @hearts.id)
    @user2 = FactoryGirl.create(:user, :game_id => @hearts.id)
    @user3 = FactoryGirl.create(:user, :game_id => @hearts.id)
    @user4 = FactoryGirl.create(:user, :game_id => @hearts.id)
  end

  describe "#setup" do

    context "#new_game" do

      it "should show that hearts game has been initiated" do
        @hearts.should be_an_instance_of HeartsGame
      end

      it "should not be over already" do
        @hearts.game_over?.should == false
      end

      it "should know it's size" do
        @hearts.size.should == 4
      end

    end

  end

  describe "#methods" do

    before :each do
      @user1.total_score = 120
      @user2.total_score = 119 
      @user3.total_score = 30  
      @user4.total_score = 110
      @user1.save
      @user2.save
      @user3.save
      @user4.save
    end

    context "#check_for_and_set_winner" do

      it "should know there is a winner" do
        @hearts.winner_id.should == nil
        @hearts.check_for_and_set_winner
        @hearts.winner_id.should_not == nil
      end
      
      it "should find the correct winner" do
        @hearts.check_for_and_set_winner
        @hearts.winner_id.should == @user3.id
      end
      
    end

    context "#find_lowest_player_id" do

      it "should find the lowest player's id" do
        @hearts.find_lowest_player_id.should == @user3.id
      end

    end

    context "#reset_scores" do

      it "should reset the player's scores" do
        @hearts.players.each do |player|
          player.total_score.should_not == 0
        end
        
        @hearts.reset_scores
        @hearts.players.each do |player|
          player.total_score.should == 0
        end
        
      end
      
    end

  end


  describe "#game_play" do

    context "#play_game" do

      it "should not crash" do
        @hearts.play_game
      # end
      end
    end
  end

end
