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
        @p_c1.is_valid?("club").should == true
      end

      it "should know that a heart is not valid" do
        @p_c3.is_valid?("club").should == false
      end
    end

    context "heart_is_lead_suit" do

      it "should know that a club is not valid" do
        @p_c1.is_valid?("heart").should == false
      end

      it "should know that a heart is valid" do
        @p_c3.is_valid?("heart").should == true
      end
    end

    context "diamond_is_lead_suit" do

      it "should know that a club is valid" do
        @p_c1.is_valid?("diamond").should == true
      end

      it "should know that a heart is valid" do
        @p_c3.is_valid?("diamond").should == true
      end
    end
    
  end
  
end
