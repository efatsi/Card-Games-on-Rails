class AddIsHumanToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :is_human, :boolean
  end
end
