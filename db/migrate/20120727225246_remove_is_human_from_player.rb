class RemoveIsHumanFromPlayer < ActiveRecord::Migration
  def change
    remove_column(:players, :is_human)
  end
end
