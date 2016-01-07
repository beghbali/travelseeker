module TripsHelper

  def user_trips(user=nil)
    trips = Array.wrap(user.try(:trips) || @trip)
    options_for_select(trips.map{|trip| [trip.name, trip_path(trip)]})
  end

  def general_tags
    %w(Food Activity Lodging)
  end

  def tag_class(tag)
    tag.downcase
  end

  def dates_or_days(trip)
    trip.dates_known? ? "#{ordinal_date trip.start_date} - #{ordinal_date trip.end_date}" : "#{trip.days} Days"
  end

  def date_or_day(date)
    date.respond_to?(:strftime) ? ordinal_date(date) : "Day #{date}"
  end

  def ordinal_date(date)
    date.strftime("%B #{date.day.ordinalize}")
  end

  def day_class(day)
    @day == day ? 'active' : ''
  end

  def show_video?
    !session[:seen_video]
  end

  def formatted_trip_day(trip, day)
    trip.dates_known? ? trip.date_on_day(day).day : day
  end

end
