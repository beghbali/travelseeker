class AddImageToClips < ActiveRecord::Migration
  def change
    add_column :clips, :image, :string
  end
end
