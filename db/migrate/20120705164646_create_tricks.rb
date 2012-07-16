class CreateTricks < ActiveRecord::Migration
  def change
    create_table :tricks do |t|
      t.integer :leader_seat
      t.string :lead_suit
      t.integer :round_id

      t.timestamps
    end
  end
end
