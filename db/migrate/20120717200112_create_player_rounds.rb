class CreatePlayerRounds < ActiveRecord::Migration
  def change
    create_table :player_rounds do |t|
      t.integer :player_id
      t.integer :round_id
      t.integer :round_score, :default => 0

      t.timestamps
    end
  end
end
