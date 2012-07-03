class AddRoomIdToDecks < ActiveRecord::Migration
  def change
    add_column :decks, :room_id, :integer
  end
end
