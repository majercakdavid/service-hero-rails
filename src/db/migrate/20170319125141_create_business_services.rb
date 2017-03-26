class CreateBusinessServices < ActiveRecord::Migration[5.0]
  def change
    create_table :business_services do |t|
      t.belongs_to :business, foreign_key: true
      t.belongs_to :service, foreign_key: true
      t.decimal :price
      t.datetime :date_added

      t.timestamps
    end
  end
end
