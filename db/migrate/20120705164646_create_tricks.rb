class CreateTricks < ActiveRecord::Migration
  def change
    create_table :tricks do |t|
      t.integer :round_id
      t.integer :leader_id
      t.integer :winner_id
      t.integer :position

      t.timestamps
    end
  end
end
