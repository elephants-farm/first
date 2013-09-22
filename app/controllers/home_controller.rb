class HomeController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:index]
  layout 'devise'
  include DeviseHelper

  def index
    if user_signed_in?
      if current_company
        redirect_to [current_company.projects.by_weight.first, :tasks] 
      else
        redirect_to welcome_path
      end
    end
  end

  def welcome
    if current_company
      redirect_to [current_company.projects.first, :tasks]
      return
    end
    render layout: 'welcome'
  end
  
  def access_denied

  end

end
