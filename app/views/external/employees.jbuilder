json.array! @employees do |employee|
  json.user employee.to_builder
end