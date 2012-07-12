require 'spec_helper'

describe Team do

  before do
    @team = FactoryGirl.create(:team)
    @user1 = FactoryGirl.create(:user, :username => "team1user1", :team_id => @team.id)
    @user2 = FactoryGirl.create(:user, :username => "team1user2", :team_id => @team.id)
    7.times do |i|
      if i%2 == 0
        @played_trick = FactoryGirl.create(:played_trick, :user_id => @user1.id)
      else
        @played_trick = FactoryGirl.create(:played_trick, :user_id => @user2.id)
      end
    end
  end
  
  it "should know it's a team" do
    @team.should be_an_instance_of Team
  end
  
  it "should know about it's two members" do
    @team.players.length.should == 2
    @team.players.should include(@user1)
    @team.players.should include(@user2)
  end
  
  it "should know the team has won 7 tricks" do
    @team.tricks_won.should == 7
  end
  
  it "for kicks should be able to get the teammates won tricks" do
    @team.players[0].tricks_won.should == 4
    @team.players[1].tricks_won.should == 3
  end
end