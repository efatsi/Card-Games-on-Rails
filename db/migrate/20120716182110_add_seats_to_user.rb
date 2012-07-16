class AddSeatsToUser < ActiveRecord::Migration
  def change
    add_column :users, :seat, :integer
  end
end
