class CreateCardsToPasses < ActiveRecord::Migration
  def change
    create_table :cards_to_passes do |t|
      t.integer :player_round_id
      t.integer :card1_id
      t.integer :card2_id
      t.integer :card3_id

      t.timestamps
    end
  end
end
