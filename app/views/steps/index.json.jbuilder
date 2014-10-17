json.array!(@steps) do |step|
  json.extract! step, :id, :time, :period, :steps
  json.url step_url(step, format: :json)
end
