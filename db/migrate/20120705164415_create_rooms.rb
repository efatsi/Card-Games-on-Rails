class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name
      t.integer :size
      t.string :game_type

      t.timestamps
    end
  end
end
