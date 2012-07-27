class AddIsReadyToCardPassingSets < ActiveRecord::Migration
  def change
    add_column(:card_passing_sets, :is_ready, :boolean)
  end
end
