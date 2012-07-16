require 'spec_helper'

describe Card do

  before do
    @user = FactoryGirl.create(:user, :username => "card_user")
    @low_club = FactoryGirl.create(:card, :suit => "club", :value => "2", :card_owner => @user)
    @high_club = FactoryGirl.create(:card, :suit => "club", :value => "9", :card_owner => @user)
    @high_heart = FactoryGirl.create(:card, :suit => "heart", :value => "9", :card_owner => @user)
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

    it "should know it's card owner" do
      @user.cards.length.should == 3
      @user.cards.should include(@low_club)
      @low_club.card_owner.should == @user
    end
    
    it "should be presentable in english" do
      @low_club.in_english.should == "2 of clubs"
    end
  end
  
  context "card_validity" do

    it "should be valid when lead suit is clubs" do
      @low_club.is_valid?("club", @user).should == true
    end

    it "should be valid when lead suit is spades" do
      @low_club.is_valid?("spade", @user).should == true
    end

    it "should not be valid when lead suit is hearts" do
      @low_club.is_valid?("heart", @user).should == false
    end
  end
  
  context "#beats?" do
    
    it "should decide higher of two with same suit" do
      @high_club.beats?(@low_club).should == true
      @low_club.beats?(@high_club).should == false
    end
    
    it "should return false for cards of different suit" do
      @low_club.beats?(@high_heart).should == false
      @high_club.beats?(@high_heart).should == false
      @high_heart.beats?(@low_club).should == false
      @high_heart.beats?(@high_club).should == false
    end  
  end
  
  context "was_played_by_username" do
    
    it "works when no one has played the card" do
      @low_club.was_played_by_username.should == ""      
    end
    
    it "works when someone has played the card" do
      @trick = FactoryGirl.create(:trick)
      @trick.set_memory_attributes(@user, @low_club)
      @low_club.was_played_by_username.should == "card_user"
    end
  end
    
end