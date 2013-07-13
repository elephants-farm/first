json.array! @projects do |project|
  json.id project.id
  json.name project.name
  json.description project.description
  json.tasks_count project.tasks.active.count

end