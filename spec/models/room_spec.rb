require 'spec_helper'

describe Room do

  before do
    @hearts_room = FactoryGirl.create(:room, :size => 4, :game_type => "Hearts")
    @spades_room = FactoryGirl.create(:room, :size => 4, :game_type => "Spades")
  end
  
  it "should know it is a room" do
    @hearts_room.should be_an_instance_of Room
    @spades_room.should be_an_instance_of Room
  end

  it "should have created a hearts/spades game" do
    @hearts_room.game.should be_an_instance_of HeartsGame
    @spades_room.game.should be_an_instance_of SpadesGame
  end
  
  it "should know the size of the game" do
    @hearts_room.size.should == 4
    @spades_room.size.should == 4
  end
end
