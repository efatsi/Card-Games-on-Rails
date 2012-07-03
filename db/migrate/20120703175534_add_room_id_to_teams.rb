class AddRoomIdToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :room_id, :integer
  end
end
