require 'spec_helper'

describe PlayerCard do
  
  before do
    @game = FactoryGirl.create(:game)
    @user = FactoryGirl.create(:user, :username => "p_c_user")
    @player = FactoryGirl.create(:player, :game_id => @game.id, :user_id => @user.id)
    @round = FactoryGirl.create(:round, :game_id => @game.id, :dealer_id => @player.id)
    @trick = FactoryGirl.create(:trick, :round_id => @round.id, :leader_id => @player.id + 1)
    @c1 = FactoryGirl.create(:card, :suit => "club", :value => "2")
    @c2 = FactoryGirl.create(:card, :suit => "club", :value => "5")
    @c3 = FactoryGirl.create(:card, :suit => "heart", :value => "5")
    @p_c1 = FactoryGirl.create(:player_card, :player_id => @player.id, :card_id => @c1.id)
    @p_c2 = FactoryGirl.create(:player_card, :player_id => @player.id, :card_id => @c2.id)
    @p_c3 = FactoryGirl.create(:player_card, :player_id => @player.id, :card_id => @c3.id)
  end
  
  describe "resource_knowledge" do
    
    it "should know it is a PlayerCard" do
      @p_c1.should be_an_instance_of PlayerCard
    end
  end
  
  describe "#choosing_abilities" do
    
    before do
      @p_r = @player.player_rounds.last
      @set = @p_r.card_passing_set
    end
    
    context "has_been_chosen?" do
      
      it "should return false for an unchosen card" do
        @p_c1.has_been_chosen?.should == false
      end
      
      it "should return true if card has been chosen" do
        @p_c1.update_attributes(:card_passing_set_id => @set.id)
        @p_c1.has_been_chosen?.should == true
      end
    end
    
    context "can_be_chosen?" do
      
      it "should return true for an unchosen card with no choices yet" do
        @p_c1.can_be_chosen?.should == true
      end
      
      it "should return true for an unchosen card with 2 choices so far" do
        @p_c1.update_attributes(:card_passing_set_id => @set.id)
        @p_c2.update_attributes(:card_passing_set_id => @set.id)
        @p_c3.can_be_chosen?.should == true
      end
      
      it "should return false for a chosen card" do        
        @p_c1.update_attributes(:card_passing_set_id => @set.id)
        @p_c1.can_be_chosen?.should == false
      end
      
      it "should return false for an unchosen card with 3 existing choices" do
        @c4 = FactoryGirl.create(:card, :suit => "diamond", :value => "A")
        @p_c4 = FactoryGirl.create(:player_card, :player_id => @player.id, :card_id => @c4.id)
        @p_c1.update_attributes(:card_passing_set_id => @set.id)
        @p_c2.update_attributes(:card_passing_set_id => @set.id)
        @p_c3.update_attributes(:card_passing_set_id => @set.id)
        @p_c4.can_be_chosen?.should == false
      end
    end
    
    
  end
  
  describe "#is_valid_lead?" do
    
    context "unbroken hearts" do
      
      it "should allow a club to be played" do
        @p_c1.send(:is_valid_lead?).should == true
      end
      
      it "should not allow a heart to be played if other options exist" do
        @p_c3.send(:is_valid_lead?).should == false
      end
      
      it "should allow a heart to be played if it is the only option" do
        @p_c1.destroy; @p_c2.destroy;
        @p_c3.send(:is_valid_lead?).should == true
      end
    end
    
    context "broken hearts" do
      
      before do
        @round.update_attributes(:hearts_broken => true)
      end
      
      it "should allow a club to be played" do
        @p_c1.send(:is_valid_lead?).should == true
      end
      
      it "should allow a heart to be played" do
        @p_c3.send(:is_valid_lead?).should == true
      end
    end
    
  end
  
  describe "#is_valid?" do

    context "club_is_lead_suit" do

      it "should know that a club is valid" do
        @p_c1.is_valid?("club", false).should == true
      end

      it "should know that a heart is not valid" do
        @p_c3.is_valid?("club", false).should == false
      end
    end

    context "heart_is_lead_suit" do

      it "should know that a club is not valid" do
        @p_c1.is_valid?("heart", false).should == false
      end

      it "should know that a heart is valid" do
        @p_c3.is_valid?("heart", false).should == true
      end
    end

    context "diamond_is_lead_suit" do

      it "should know that a club is valid" do
        @p_c1.is_valid?("diamond", false).should == true
      end

      it "should know that a heart is valid" do
        @p_c3.is_valid?("diamond", false).should == true
      end
    end
    
    context "first trick" do
      
      before do
        @c1.update_attributes(:suit => "spade", :value => "5")
        @c2.update_attributes(:suit => "diamond", :value => "3")
        @c4 = FactoryGirl.create(:card, :suit => "spade", :value => "Q")
        @p_c4 = FactoryGirl.create(:player_card, :player_id => @player.id, :card_id => @c4.id)
      end
      
      it "should not let you play a scoring card if you have no clubs" do
        @p_c1.is_valid?("club", true).should == true
        @p_c2.is_valid?("club", true).should == true
        @p_c3.is_valid?("club", true).should == false
        @p_c4.is_valid?("club", true).should == false
      end
      
    end
    
  end
  
end
