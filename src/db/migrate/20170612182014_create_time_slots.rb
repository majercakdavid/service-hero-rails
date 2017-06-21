class CreateTimeSlots < ActiveRecord::Migration[5.0]
  def change
    create_table :time_slots do |t|
      t.datetime :datetime_from
      t.datetime :datetime_to
      t.references :business_service, foreign_key: true

      t.timestamps
    end
    add_column :business_services, :enable_time_slots, :boolean, :default => false
  end
end
