require 'spec_helper'

describe Player do
  
  before do
    @player = FactoryGirl.create(:player)
  end
  
  describe "resource_knowledge" do
    
    it "should know it is a played_card" do
      @player.should be_an_instance_of Player
    end
  end
  
  
end
