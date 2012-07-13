class AddWasPlayedByToCards < ActiveRecord::Migration
  def change
    add_column :cards, :was_played_by_id, :integer
  end
end
