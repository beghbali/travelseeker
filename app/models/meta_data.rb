class MetaData
  %i(latitude longitude name image_url address phone hours rating_image_url).each do |method|
    define_method method do
    end
  end
end