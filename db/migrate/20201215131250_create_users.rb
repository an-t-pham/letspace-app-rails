class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.belongs_to :landlord, null: false, foreign_key: true
      t.belongs_to :tenant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
