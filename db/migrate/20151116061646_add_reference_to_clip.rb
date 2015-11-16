class AddReferenceToClip < ActiveRecord::Migration
  def change
    add_column :clips, :reference, :string
    add_column :clips, :latitude, :float
    add_column :clips, :longitude, :float
  end
end
