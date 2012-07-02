class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.integer :bid
      t.integer :bags
      t.integer :tricks_won
      t.integer :round_score
      t.integer :total_score

      t.timestamps
    end
  end
end
