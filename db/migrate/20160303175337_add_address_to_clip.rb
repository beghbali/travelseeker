class AddAddressToClip < ActiveRecord::Migration
  def change
    add_column :clips, :address, :string
  end
end
