require 'spec_helper'

describe SpadesGame do

  before :all do
    @spades = SpadesGame.create(:size => 4)
    @user1 = FactoryGirl.create(:user, :game_id => @spades.id)
    @user2 = FactoryGirl.create(:user, :game_id => @spades.id)
    @user3 = FactoryGirl.create(:user, :game_id => @spades.id)
    @user4 = FactoryGirl.create(:user, :game_id => @spades.id)
    @team1 = FactoryGirl.create(:team, :game_id => @spades.id)
    @team2 = FactoryGirl.create(:team, :game_id => @spades.id)
  end

  after :all do
    User.delete_all
    Game.delete_all
    Deck.delete_all
    Team.delete_all
  end

  context "#setup" do

    context "#new_game" do

      it "should show that spades game has been initiated" do
        @spades.should be_an_instance_of SpadesGame
      end

      it "should not be over already" do
        @spades.game_over?.should == false
      end

      it "should know it's size" do
        @spades.size.should == 4
      end

    end

  end
  
  describe "#teams" do
    
    context "#setting_the_teams" do
      
      it "should set the teams with 2 players each" do
        @spades.set_teams
        @team1.players.length.should == 2
        @team2.players.length.should == 2
      end
      
      it "should have put opposite players on each team" do
        @spades.set_teams
        @team1.players.first.should == @user1
        @team2.players.first.should == @user2
        @team1.players.last.should == @user3
        @team2.players.last.should == @user4
      end
      
    end
  end

  describe "#methods" do

    before :all do
      @spades.set_teams
      @team1.update_attributes(:total_score => 510)
      @team2.update_attributes(:total_score => 610)
    end

    context "#check_for_winner" do
      
      it "should know there is a winner" do
        @spades.winner_id.should == nil
        @spades.check_for_winner
        @spades.winner_id.should_not == nil
      end

      it "should find the correct winner" do
        @spades.check_for_winner
        @spades.winner_id.should == @team2.id
      end
      
    end

    context "#reset_scores" do

      it "should reset the player's scores" do
        @spades.teams.each do |team|
          team.total_score.should_not == 0
        end
        
        @spades.reset_scores
        @spades.teams.each do |team|
          team.total_score.should == 0
        end
        
      end
      
    end

  end


  pending "#game_play" do

    context "#play_game" do

      it "should not crash" do
        @spades.play_game
      end
    end
  end

end
