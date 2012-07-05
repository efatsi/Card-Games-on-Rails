require 'spec_helper'

describe "played_tricks/index" do
  before(:each) do
    assign(:played_tricks, [
      stub_model(PlayedTrick,
        :size => 1,
        :trick_owner_type => "Trick Owner Type",
        :trick_owner_id => 2
      ),
      stub_model(PlayedTrick,
        :size => 1,
        :trick_owner_type => "Trick Owner Type",
        :trick_owner_id => 2
      )
    ])
  end

  it "renders a list of played_tricks" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Trick Owner Type".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
