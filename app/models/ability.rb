class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    
    if user.is? :admin
        can :list_tasks, Project do |project|
           true
        end
        can :admin_projects, nil
    end
    
  end
end
