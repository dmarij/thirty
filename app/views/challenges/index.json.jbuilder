json.array!(@challenges) do |challenge|
  json.extract! challenge, :title, :duration, :description
  json.url challenge_url(challenge, format: :json)
end
