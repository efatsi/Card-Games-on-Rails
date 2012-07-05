class AddGameIdToDecks < ActiveRecord::Migration
  def change
    add_column :decks, :game_id, :integer
  end
end
