class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.belongs_to :customer, foreign_key: true
      t.datetime :date_created

      t.timestamps
    end
  end
end
