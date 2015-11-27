module ClipsHelper

  def last_clip?(clip)
    Clip.for_session(session.id).first.id == clip.id
  end

  def tags_placeholder_for(clip)
    clip.tag_list.any? ? nil : 'Add tags/categories'
  end

  def format_hours(hours_string)
    hours_string && hours_string.gsub(/\n+/, '<br>').html_safe
  end
end
