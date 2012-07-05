class AddALotToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :size, :integer
    add_column :rooms, :rounds_played, :integer
    add_column :rooms, :tricks_played, :integer
    add_column :rooms, :lead_suit, :string
    add_column :rooms, :winner_id, :integer
    add_column :rooms, :dealer_id, :integer
    add_column :rooms, :leader_id, :integer
  end
end