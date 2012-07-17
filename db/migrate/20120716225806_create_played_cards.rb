class CreatePlayedCards < ActiveRecord::Migration
  def change
    create_table :played_cards do |t|
      t.integer :trick_id
      t.integer :player_card_id
      t.integer :position

      t.timestamps
    end
  end
end
