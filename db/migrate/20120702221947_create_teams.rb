class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.integer :bid, :default => 0
      t.integer :bags, :default => 0
      t.integer :tricks_won, :default => 0
      t.integer :round_score, :default => 0
      t.integer :total_score, :default => 0

      t.timestamps
    end
  end
end
