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
    when :seattle, :london, :berkeley
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
        "Easily find awsome things to do in #{@request.destination}"
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
        "The personal guidebook you always wished for"
      else
        "Custom travel recommendations from people like you"
      end
    else
      "Custom travel recommendations from trusted locals"
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