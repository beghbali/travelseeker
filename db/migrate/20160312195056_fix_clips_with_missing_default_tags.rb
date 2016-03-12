class FixClipsWithMissingDefaultTags < ActiveRecord::Migration
  def change
    Clip.find_each do |clip|
      clip.ensure_tagged
      clip.save
    end
  end
end
