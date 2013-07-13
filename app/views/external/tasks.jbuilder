json.tasks do
  json.array! @tasks do |task|
    json.id task.id
    json.project_id task.project_id
    json.name task.name
    json.description task.description
    json.priority task.priority
    json.status task.status
    
    json.dead_line_time task.dead_line_time
    json.finish_to_time task.finish_to_time
    
    json.assigned_users do
        json.array! task.assigned_users do |user|
            json.user user.to_builder
        end
    end

    json.author task.author.to_builder
    
    json.assigned_to_user_id task.assigned_to_user_id

    json.assigned_to task.assigned_to.nil? ? nil : task.assigned_to.to_builder

    json.tags do
        json.array! task.tags do |tag|
            json.tag tag.to_builder
        end
    end

  end
end
