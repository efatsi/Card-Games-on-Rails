class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.integer :user_id
      t.integer :game_id
      t.integer :seat
      t.integer :total_score, :default => 0

      t.timestamps
    end
  end
end
