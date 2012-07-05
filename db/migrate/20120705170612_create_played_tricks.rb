class CreatePlayedTricks < ActiveRecord::Migration
  def change
    create_table :played_tricks do |t|
      t.integer :size
      t.string :trick_owner_type
      t.integer :trick_owner_id

      t.timestamps
    end
  end
end
