class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.integer :dealer_id
      t.integer :room_id

      t.timestamps
    end
  end
end
