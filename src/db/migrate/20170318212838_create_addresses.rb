class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.string :name
      t.string :street
      t.string :city
      t.string :ZIP
      t.string :state
      t.string :country
      t.string :phone

      t.decimal :latitude
      t.decimal :longitude

      t.timestamps
    end
  end
end
