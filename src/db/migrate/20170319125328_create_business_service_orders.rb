class CreateBusinessServiceOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :business_service_orders do |t|
      t.references :business_service, foreign_key: true
      t.references :order, foreign_key: true
      t.string :label
      t.text :description
      t.datetime :date_created

      t.timestamps
    end
  end
end
