class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.integer :game_id
      t.integer :dealer_id
      t.integer :position, :default => 0

      t.timestamps
    end
  end
end
