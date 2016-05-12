class AddSourceToClips < ActiveRecord::Migration
  def change
    add_column :clips, :source_id, :integer
  end
end
