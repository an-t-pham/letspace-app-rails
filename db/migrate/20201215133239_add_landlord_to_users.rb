class AddLandlordToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :landlord, :boolean, default: false
  end
end
