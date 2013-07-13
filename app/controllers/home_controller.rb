class HomeController < ApplicationController
  skip_before_filter :authenticate_user!
  layout 'devise'
  include DeviseHelper

  def index
    if user_signed_in?
      redirect_to [current_company.projects.first, :tasks] 
    end
  
  end
end
