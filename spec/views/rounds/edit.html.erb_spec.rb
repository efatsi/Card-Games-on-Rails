require 'spec_helper'

describe "rounds/edit" do
  before(:each) do
    @round = assign(:round, stub_model(Round,
      :dealer_id => 1,
      :room_id => 1
    ))
  end

  it "renders the edit round form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => rounds_path(@round), :method => "post" do
      assert_select "input#round_dealer_id", :name => "round[dealer_id]"
      assert_select "input#round_room_id", :name => "round[room_id]"
    end
  end
end
