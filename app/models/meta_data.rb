class MetaData

  %i(latitude longitude name image_url address phone hours rating_image_url ).each do |method|
    define_method method do
      unless is_a?(GooglePlacesMetaData) || is_a?(WeblinkMetaData)
        client = GooglePlacesMetaData.new(name, Location.new(latitude: latitude, longitude: longitude))
        client.send(method)
      end
    end

    %i(city state country type).each do |method|
      define_method method do
      end
    end
  end
end