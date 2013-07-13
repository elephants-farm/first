json.array! @comments do |comment|
  json.id comment.id
  json.title comment.title
  json.description comment.description
  json.author comment.user.to_builder
  
end