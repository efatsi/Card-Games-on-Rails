require 'spec_helper'

describe CardPassingSet do

  before do
    @p_r = FactoryGirl.create(:player_round, :player_id => 100, :round_id => 100)
    @cps = FactoryGirl.create(:card_passing_set, :player_round_id => @p_r.id)
  end
  
  describe "#methods" do
    
    context "is_not_ready" do
      
      it "is super dumb and simple, and should work" do
        @cps.is_not_ready?.should == true
      end
      
      it "should return true when it has to too" do
        @cps.update_attributes(:is_ready => true)
        @cps.is_not_ready?.should == false
      end
    end
    
  end

end
