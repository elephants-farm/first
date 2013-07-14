json.tasks do
  json.array! @tasks do |task|   
    json.partial! template: 'external/task', locals: {task: task}
  end
end
