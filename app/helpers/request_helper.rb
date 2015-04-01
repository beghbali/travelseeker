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

  %w(lodging thingstosee thingstodo dining).each do |image_type|
    define_method "#{image_type}_image" do
      @request.destination.blank? ? image_tag("#{image_type}.png") : image_tag("#{image_type}_#{@request.destination.downcase}.jpg")
    end
  end

  private def to_dest(destination)
    destination.try(:downcase).try(:to_sym)
  end
end