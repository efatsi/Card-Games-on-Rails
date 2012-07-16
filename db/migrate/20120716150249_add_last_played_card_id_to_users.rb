class AddLastPlayedCardIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_played_card_id, :integer
  end
end
