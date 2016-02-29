class FixClipsThatLostUnassigned < ActiveRecord::Migration
  def change
    Clip.find_each do |clip|
      if clip.scheduled_at.nil? && !clip.day_list.include?('Unassigned')
        clip.day_list.add 'Unassigned'
        clip.save
      end
    end
  end
end
