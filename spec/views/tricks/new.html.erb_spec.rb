require 'spec_helper'

describe "tricks/new" do
  before(:each) do
    assign(:trick, stub_model(Trick,
      :leader_id => 1,
      :lead_suit => "MyString",
      :round_id => 1
    ).as_new_record)
  end

  it "renders new trick form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tricks_path, :method => "post" do
      assert_select "input#trick_leader_id", :name => "trick[leader_id]"
      assert_select "input#trick_lead_suit", :name => "trick[lead_suit]"
      assert_select "input#trick_round_id", :name => "trick[round_id]"
    end
  end
end
