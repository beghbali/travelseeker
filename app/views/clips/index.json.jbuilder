json.array!(@clips) do |clip|
  json.extract! clip, :id
  json.url clip_url(clip, format: :json)
end
