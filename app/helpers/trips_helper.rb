module TripsHelper

  def user_trips(user=current_user)
    trips = Array.wrap(user.try(:trips) || @trip).reverse
    options_for_select(trips.map{|trip| [trip.name, trip_path(trip)]}, trip_path(@trip))
  end

  def general_tags
    %w(Food Activity Lodging Unassigned)
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

  def show_tips?
    !session[:seen_tips]
  end

  def tooltip_options
    show_tips? ? {'data-toggle' => 'tooltip', 'data-placement' => 'bottom', title: 'TravelSeeker helps you collect what excites you. Look up ideas using your preferred sources of inspiration, such as WikiVoyage or TripAdvisor, then add those ideas here'} : {}
  end

  def formatted_trip_day(trip, day)
    trip.dates_known? ? trip.date_on_day(day).day.ordinalize : day.ordinalize
  end

  def dates(trip)
    trip.dates_known? ? "#{formatted_trip_day(trip, 1)} - #{formatted_trip_day(trip, trip.days-1)}" : ""
  end

  def add_or_change_dates(trip)
    trip.dates_known? ? 'Change dates' : 'Add dates'
  end

  def show_wishlist_class(wishlist_shown, trip)
    wishlist_shown[trip.id] ? 'hidden' : ''
  end
end
