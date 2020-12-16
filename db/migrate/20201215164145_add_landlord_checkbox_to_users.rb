class AddLandlordCheckboxToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :landlord_checkbox, :boolean, default: false
  end
end
