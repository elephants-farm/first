class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :online_at
  belongs_to :user_profile
  belongs_to :company
  has_and_belongs_to_many :tasks

  scope :online, lambda{ where("updated_at > ?", 10.minutes.ago) }
  #many roles per user https://github.com/ryanb/cancan/wiki/Role-Based-Authorization
  def admin?
    self.role.to_sym == :admin
  end

  def online?
    updated_at > 20.minutes.ago
  end
  
  def is?(search_role)
    return false if role.nil?
    roles_arr = role.split(' ').map { |role| role.to_sym }
    roles_arr.include?(search_role)
  end

  def to_builder
    Jbuilder.new do |user|
      user.id id
      user.email email
      user.name user_profile.name
      user.surname user_profile.surname
      user.tasks_count tasks.active.count
      user.online online?
      user.avatar do |avatar|
        avatar.micro user_profile.avatar.url(:micro) 
        avatar.mini user_profile.avatar.url(:mini) 
      end
    end
  end

end
