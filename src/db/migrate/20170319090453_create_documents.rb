class CreateDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :documents do |t|
      t.belongs_to :documentable, polymorphic: true
      t.string :label
      t.binary :data
      t.text :dataurl
      t.text :description

      t.timestamps
    end
    add_index :documents, [:documentable_id, :documentable_type]
  end
end
