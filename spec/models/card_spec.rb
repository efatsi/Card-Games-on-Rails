require 'spec_helper'

describe Card do

  before do
    @low_club = FactoryGirl.create(:card, :suit => "club", :value => "2")
    @high_club = FactoryGirl.create(:card, :suit => "club", :value => "9")
    @high_heart = FactoryGirl.create(:card, :suit => "heart", :value => "K")
  end
  
  context "resource_knowledge" do
    
    it "should know it is a card" do
      @low_club.should be_an_instance_of Card
    end

    it "should know it's suit" do
      @low_club.suit.should == "club"
    end

    it "should know it's value" do
      @low_club.value.should == "2"
    end
  end
  
  context "in_english" do
    
    it "should display the card properly" do
      @low_club.in_english.should == "2 of clubs"
      @high_club.in_english.should == "9 of clubs"
      @high_heart.in_english.should == "K of hearts"
    end
  end
    
end