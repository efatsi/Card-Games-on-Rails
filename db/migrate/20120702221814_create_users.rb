class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.integer :total_score, :default => 0
      t.integer :round_score, :default => 0
      t.integer :bid, :default => 0
      t.boolean :going_nil, :default => false
      t.boolean :going_blind, :default => false
      t.integer :team_id

      t.timestamps
    end
  end
end
