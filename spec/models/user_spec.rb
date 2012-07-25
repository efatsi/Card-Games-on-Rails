require 'spec_helper'

describe User do

  before do
    @game = FactoryGirl.create(:game)
    @user = FactoryGirl.create(:user, :username => "user_user", :password => "secret", :password_confirmation => "secret")
    @player = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user.id, :seat => 0)
  end
  
  describe "#resource_knowledge" do
    
    it "should know it is a user" do
      @user.should be_an_instance_of User
    end
    
    it "should know it's username" do
      @user.username.should == "user_user"
    end
    
    it "should be able to authenticate" do
      (@user == User.authenticate("user_user", "secret")).should == true
      (@user == User.authenticate("user_user", "wrong_password")).should == false
    end
    
    it "should know about it's current player" do
      @user.current_player.should == @player
      @game2 = FactoryGirl.create(:game)
      @player2 = FactoryGirl.create(:player, :game_id => @game2.id, :user_id => @user.id, :seat => 0)
      @user.current_player.should == @player2
    end
    
    it "should know it is in a game" do
      @user.is_playing_in?(@game).should == true
      @game2 = FactoryGirl.create(:game)
      @player2 = FactoryGirl.create(:player, :game_id => @game2.id, :user_id => @user.id, :seat => 0)
      @user.is_playing_in?(@game).should == false
      @user.is_playing_in?(@game2).should == true
    end
  end



end