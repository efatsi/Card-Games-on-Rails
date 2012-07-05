class AddPolymorphismToCards < ActiveRecord::Migration
  def change
    add_column :cards, :card_owner_type, :string
    add_column :cards, :card_owner_id, :integer
  end
end
