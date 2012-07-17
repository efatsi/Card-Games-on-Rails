require 'spec_helper'

describe PlayerCard do
  
  before do
    @player_card = FactoryGirl.create(:player_card)
  end
  
  describe "resource_knowledge" do
    
    it "should know it is a PlayerCard" do
      @player_card.should be_an_instance_of PlayerCard
    end
  end
  
  
end
