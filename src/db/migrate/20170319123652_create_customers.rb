class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers do |t|
      t.references :billing_address, foreign_key: { to_table: :addresses }
      t.references :shipping_address, foreign_key: { to_table: :addresses }
      t.string :email
      t.string :password_digest
      t.string :name
      t.datetime :date_joined

      t.timestamps
    end
  end
end
