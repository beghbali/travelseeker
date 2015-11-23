class MetaData

  %i(latitude longitude name image_url address phone hours rating_image_url ).each do |method|
    define_method method do
      unless is_a?(GooglePlacesMetaData)
        puts self.class.name
        puts name
        puts method
        client = GooglePlacesMetaData.new(name, Location.new(latitude: latitude, longitude: longitude))
        client.send(method)
      end
    end
  end
end