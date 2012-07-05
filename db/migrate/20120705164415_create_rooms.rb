class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.integer :size
      t.string :game
      t.integer :winner_id

      t.timestamps
    end
  end
end
