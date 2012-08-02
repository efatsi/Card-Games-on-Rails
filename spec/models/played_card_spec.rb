require 'spec_helper'

describe PlayedCard do
  
  before :all do
    User.delete_all
    @user1 = FactoryGirl.create(:user, :username => "trick_user1")
    @user2 = FactoryGirl.create(:user, :username => "trick_user2")
    @player1 = FactoryGirl.create(:player, :user_id => @user1.id)
    @player2 = FactoryGirl.create(:player, :user_id => @user2.id)
    @trick = FactoryGirl.create(:trick, :round_id => 2, :leader_id => @player1.id)    
  end

  describe "beats?" do
  
    context "with similar suits" do
      
      before do
        @c1 = FactoryGirl.create(:card, :suit => "club", :value => "2")
        @c2 = FactoryGirl.create(:card, :suit => "club", :value => "5")
        @p1 = FactoryGirl.create(:player_card, :player_id => @player1.id, :card_id => @c1.id)
        @p2 = FactoryGirl.create(:player_card, :player_id => @player2.id, :card_id => @c2.id)
        @pc1 = FactoryGirl.create(:played_card, :player_card_id => @p1.id, :trick_id => @trick.id, :position => 0)
        @pc2 = FactoryGirl.create(:played_card, :player_card_id => @p2.id, :trick_id => @trick.id, :position => 1)
      end
      
      it "should work with simple numbers" do
        @pc1.beats?(@pc1).should == false
        @pc2.beats?(@pc2).should == false
        @pc1.beats?(@pc2).should == false
        @pc2.beats?(@pc1).should == true
      end

      it "should work with number vs. face value" do
        @c2.update_attributes(:value => "K")
        @pc1.beats?(@pc2).should == false
        @pc2.beats?(@pc1).should == true
      end

      it "works with J/Q" do
        @c1.update_attributes(:value => "J")
        @c2.update_attributes(:value => "Q")
        @pc1.beats?(@pc2).should == false
        @pc2.beats?(@pc1).should == true
      end

      it "works with J/K" do
        @c1.update_attributes(:value => "J")
        @c2.update_attributes(:value => "K")
        @pc1.beats?(@pc2).should == false
        @pc2.beats?(@pc1).should == true
      end

      it "works with J/A" do
        @c1.update_attributes(:value => "J")
        @c2.update_attributes(:value => "A")
        @pc1.beats?(@pc2).should == false
        @pc2.beats?(@pc1).should == true
      end

      it "works with Q/K" do
        @c1.update_attributes(:value => "Q")
        @c2.update_attributes(:value => "K")
        @pc1.beats?(@pc2).should == false
        @pc2.beats?(@pc1).should == true
      end

      it "works with Q/A" do
        @c1.update_attributes(:value => "Q")
        @c2.update_attributes(:value => "A")
        @pc1.beats?(@pc2).should == false
        @pc2.beats?(@pc1).should == true
      end

      it "works with K/A" do
        @c1.update_attributes(:value => "K")
        @c2.update_attributes(:value => "A")
        @pc1.beats?(@pc2).should == false
        @pc2.beats?(@pc1).should == true
      end
      
    end
  end
end