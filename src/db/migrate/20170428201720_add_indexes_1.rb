class AddIndexes1 < ActiveRecord::Migration[5.0]
  def change
    #add_index :business_business_owners, :business_id
    #add_index :business_business_owners, :business_owner_id
    #add_index :business_services, :business_id
    #add_index :business_service_orders, :business_service_id
    add_index :business_service_orders, :date_created
    #add_index :employees, :businesses_id
    add_index :businesses, :name
  end
end
