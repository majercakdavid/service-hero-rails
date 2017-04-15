class CreateBusinessOwners < ActiveRecord::Migration[5.0]
  def change
    create_table :business_owners do |t|
      t.references :billing_address, foreign_key: { to_table: :addresses }
      t.references :shipping_address, foreign_key: { to_table: :addresses }
      t.string :name

      t.timestamps
    end
  end
end
