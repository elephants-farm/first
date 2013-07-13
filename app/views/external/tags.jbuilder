json.tags do
  json.array! tags do |tag|
    json.tag tag.to_builder
  end
end