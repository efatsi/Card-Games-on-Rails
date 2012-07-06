require 'spec_helper'

describe Game do

  before :all do
    @game = Game.create(:size => 4)
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @user3 = FactoryGirl.create(:user)
    @user4 = FactoryGirl.create(:user)
    @deck = FactoryGirl.create(:deck)
  end
  
  after :all do
    User.delete_all
    Game.delete_all
    Deck.delete_all
  end

  describe "#setup" do

    context "#new_game" do

      it "should show that game has been initiated" do
        @game.should be_an_instance_of Game
      end
      
      it "should not be over already" do
        @game.game_over?.should == false
      end
      
      it "should know it's size" do
        @game.size.should == 4
      end
      
    end
    
    pending "#deck" do
      
      before :all do
        @deck.game_id = @game.id
        @deck.save
      end
      it "should know about it's deck" do
        @game.deck.should be_an_instance_of Deck
      end
      
    end
    
    context "#players" do

      before :all do
        @user1.game_id = @game.id; @user1.save
        @user2.game_id = @game.id; @user2.save
        @user3.game_id = @game.id; @user3.save
        @user4.game_id = @game.id; @user4.save
      end
      
      it "should know about it's players" do
        @game.players.length.should == 4
      end

    end

  end
end
