module ClipsHelper

  def last_clip?(clip)
    Clip.for_session(session.id).first.id == clip.id
  end

  def tags_placeholder_for(clip)
    clip.tag_list.any? ? 'e.g. lodging, first day, paris, etc' : nil
  end
end
