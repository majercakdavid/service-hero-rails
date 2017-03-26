class CreateServices < ActiveRecord::Migration[5.0]
  def change
    create_table :services do |t|
      t.string :label
      t.text :description
      t.datetime :date_added

      t.timestamps
    end
  end
end
