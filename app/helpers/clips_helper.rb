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

  def google_static_map_url(location, width)
    require 'uri'
    "https://maps.googleapis.com/maps/api/staticmap?key=#{ENV['GOOGLE_API_KEY']}&size=300x200&markers=icon:#{URI.encode(asset_path('pin_highlighted.svg'))}|#{[location.latitude, location.longitude].join(',')}"
  end

  def scheduled_label(clip)
    return "Date/Time"

    if clip.transit?
      "Add Departure Time"
    elsif clip.lodging?
      "Add Checkin Time"
    else
      "Add Reservation Time"
    end
  end

  def present_commitment(clip)
    return "" if clip.scheduled_time.nil?
    begin
      if clip.transit?
        "departs at"
      elsif clip.lodging?
        "checkin at"
      else
        "reservation at"
      end
    end + " #{clip.scheduled_time}"
  end

  def scheduled_class(clip)
    clip.scheduled_time.present? ? '' : 'hidden'
  end

  def icon_path(clip)
    asset_path("#{clip.type_list.first.downcase}.svg")
  end
end
