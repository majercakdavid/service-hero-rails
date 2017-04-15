class CreateBusinessBusinessOwners < ActiveRecord::Migration[5.0]
  def change
    create_table :business_business_owners do |t|
      t.references :business, foreign_key: true
      t.references :business_owner, foreign_key: true
      t.datetime :date_from
      t.datetime :date_to

      t.timestamps
    end
  end
end
