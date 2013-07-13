class Company < ActiveRecord::Base
  attr_accessible :name
  has_many :users
  has_many :projects

  def one_human?
    self.users.count == 1
  end
end
