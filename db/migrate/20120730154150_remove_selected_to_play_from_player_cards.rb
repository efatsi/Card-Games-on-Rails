class RemoveSelectedToPlayFromPlayerCards < ActiveRecord::Migration
  def change
    remove_column(:player_cards, :selected_for_play)
  end
end
