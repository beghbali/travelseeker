class MetaData
  %i(latitude longitude name image_url address).each do |method|
    define_method method do
    end
  end
end