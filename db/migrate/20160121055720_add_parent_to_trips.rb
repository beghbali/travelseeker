class AddParentToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :parent_id, :integer
  end
end
