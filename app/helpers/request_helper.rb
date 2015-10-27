module RequestHelper

  def css_for(destination)
    dest = to_dest(destination)
    image_name = "#{dest}.jpg"
    css = []
    if Rails.application.assets.find_asset(image_name)
      css << "background-image: url(#{asset_path(image_name)}); "
    end
    css << "color: #{text_color_for(dest)}"
    css.join(";")
  end

  def text_color_for(destination)
    case to_dest(destination)
    when :seattle, :london
      'white'
    else
      'inherit'
    end
  end

  def survey(destination)
    {
      seattle: 'https://www.getfeedback.com/r/dwsxcfQS',
      berkeley: 'https://www.getfeedback.com/r/pKva6Idf'
    }[to_dest(destination)]
  end

  %w(lodging thingstosee thingstodo dining).each do |image_type|
    define_method "#{image_type}_image" do
      @request.destination.blank? ? image_tag("#{image_type}.png") : image_tag("#{image_type}_#{@request.destination.downcase}.jpg")
    end
  end

  def plan
    if @request.destination.present?
      case params[:version]
      when 2
        "Easily find awesome things to do in #{@request.destination}"
      when 3
        "Plan your ideal #{@request.destination} trip in less than 10 minutes"
      else
        "Experience #{@request.destination} like a local, not a tourist"
      end
    else
      "Travel like a local, not a tourist"
    end
  end

  def slogan
    if @request.destination.present?
      case params[:version]
      when 2
        "The personal guidebook you always wished for. #{link_to 'See a sample.', asset_path('Seattle Free Ideas Example.pdf')}"
      when 3
        "Your personal travel advisor for #{@request.destination}. Get free #{link_to 'activity ideas', asset_path('Seattle Free Ideas Example.pdf')}, Upgrade to full #{link_to 'itinerary recommendation', asset_path('Seattle Paid Itinerary Example.pdf')}"
      else
        "Custom travel recommendations from people like you. #{link_to 'See a sample.', asset_path('Seattle Free Ideas Example.pdf')}"
      end
    else
      "Custom travel recommendations from trusted locals. #{link_to 'See a sample.', asset_path('Seattle Free Ideas Example.pdf')}"
    end
  end

  def value
    if @request.destination.present?
      case params[:version]
      when 2
        "Unbiased #{@request.destination} activity ideas and planning help"
      else
        "Easily find activities, dining, and lodging you'll love"
      end
    else
      "We're the travel concierge for a new generation of travelers"
    end
  end

  def what

    if @request.destination.present?
      case params[:version]
      when 2
        "Like having your friend recommend the best experiences"
      else
        "Like having a local friend everywhere you travel"
      end
    else
      "Like having a local friend everywhere you travel"
    end
  end

  private def to_dest(destination)
    destination.try(:downcase).try(:to_sym)
  end
end