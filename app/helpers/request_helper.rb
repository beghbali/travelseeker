module RequestHelper

  def background_image_for(destination)
    image_name = "#{destination.try(:downcase)}.jpg"
    if Rails.application.assets.find_asset(image_name)
      "background-image: url(#{asset_path(image_name)})"
    else
      ""
    end
  end
end