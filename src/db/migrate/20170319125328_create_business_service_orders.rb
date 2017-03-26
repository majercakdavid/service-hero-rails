class CreateBusinessServiceOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :business_service_orders do |t|
      t.belongs_to :business_service, foreign_key: true
      t.belongs_to :order, foreign_key: true
      t.string :label
      t.text :description
      t.datetime :date_created

      t.timestamps
    end
  end
end
