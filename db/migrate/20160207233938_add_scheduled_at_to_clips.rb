class AddScheduledAtToClips < ActiveRecord::Migration
  def change
    add_column :clips, :scheduled_at, :datetime
  end
end
