class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.integer :total_score
      t.integer :round_score
      t.integer :bid
      t.boolean :going_nil
      t.boolean :going_blind
      t.integer :team_id

      t.timestamps
    end
  end
end
