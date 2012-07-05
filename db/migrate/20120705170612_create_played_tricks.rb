class CreatePlayedTricks < ActiveRecord::Migration
  def change
    create_table :played_tricks do |t|
      t.integer :size
      t.string :player_id
      t.integer :round_id

      t.timestamps
    end
  end
end
