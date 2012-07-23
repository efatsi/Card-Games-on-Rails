class CreatePlayerCards < ActiveRecord::Migration
  def change
    create_table :player_cards do |t|
      t.integer :player_id
      t.integer :card_id
      t.integer :card_passing_set_id

      t.timestamps
    end
  end
end
