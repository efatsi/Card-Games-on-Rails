require 'spec_helper'

describe "tricks/edit" do
  before(:each) do
    @trick = assign(:trick, stub_model(Trick,
      :leader_id => 1,
      :lead_suit => "MyString",
      :round_id => 1
    ))
  end

  it "renders the edit trick form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tricks_path(@trick), :method => "post" do
      assert_select "input#trick_leader_id", :name => "trick[leader_id]"
      assert_select "input#trick_lead_suit", :name => "trick[lead_suit]"
      assert_select "input#trick_round_id", :name => "trick[round_id]"
    end
  end
end
