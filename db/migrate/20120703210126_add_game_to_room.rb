class AddGameToRoom < ActiveRecord::Migration
  def change
    add_column :rooms, :game, :string
  end
end
