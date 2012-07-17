require 'spec_helper'

describe Game do
  
  before do
    @game = FactoryGirl.create(:game, :size => 4)
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
    
    pending "#players" do
      
      it "should know about it's players" do
        @game.players.length.should == 4
      end
    end

  end

  pending "#methods" do
    
  end
end
