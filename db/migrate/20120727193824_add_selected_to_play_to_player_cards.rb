class AddSelectedToPlayToPlayerCards < ActiveRecord::Migration
  def change
    add_column(:player_cards, :selected_for_play, :boolean, :default => false)
  end
end
