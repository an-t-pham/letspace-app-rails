class CreateProperties < ActiveRecord::Migration[6.0]
  def change
    create_table :properties do |t|
      t.string :address
      t.integer :price
      t.string :description
      t.string :image_url
      t.belongs_to :landlord, null: false, foreign_key: true
      t.belongs_to :tenant, null: true, foreign_key: true
    end
  end
end
