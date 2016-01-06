class AddTripIdToClips < ActiveRecord::Migration
  def change
    add_column :clips, :trip_id, :integer
  end
end
