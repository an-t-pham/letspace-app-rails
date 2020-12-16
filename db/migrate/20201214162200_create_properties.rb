class CreateProperties < ActiveRecord::Migration[6.0]
  def change
    create_table :properties do |t|
      t.string :address
      t.string :price
      t.string :description
      t.string :image_url
      t.belongs_to :landlord, foreign_key: true

      t.timestamps
    end
  end
end
