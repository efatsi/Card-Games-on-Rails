require 'spec_helper'

describe "played_tricks/edit" do
  before(:each) do
    @played_trick = assign(:played_trick, stub_model(PlayedTrick,
      :size => 1,
      :trick_owner_type => "MyString",
      :trick_owner_id => 1
    ))
  end

  it "renders the edit played_trick form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => played_tricks_path(@played_trick), :method => "post" do
      assert_select "input#played_trick_size", :name => "played_trick[size]"
      assert_select "input#played_trick_trick_owner_type", :name => "played_trick[trick_owner_type]"
      assert_select "input#played_trick_trick_owner_id", :name => "played_trick[trick_owner_id]"
    end
  end
end
