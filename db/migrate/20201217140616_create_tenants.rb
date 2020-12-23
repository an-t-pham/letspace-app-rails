class CreateTenants < ActiveRecord::Migration[6.0]
  def change
    create_table :tenants do |t|
      t.belongs_to :user, null: false, foreign_key: true
    end
  end
end
