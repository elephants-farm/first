class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    
    if user.admin?
        can :list_tasks, Project do |project|
           true
        end

    end
    
  end
end
