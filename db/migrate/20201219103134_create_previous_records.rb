class CreatePreviousRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :previous_records do |t|
      t.belongs_to :tenant, null: false, foreign_key: true
      t.belongs_to :property, null: false, foreign_key: true

      t.timestamps
    end
  end
end
