 #c = Company.create!(name: 'kostenko linen')
 #ActiveRecord::Base.connection.execute("update users set company_id = #{c.id}")
 #ActiveRecord::Base.connection.execute("update projects set company_id = #{c.id}")

class ApplicationController < ActionController::Base
  before_filter :sign_in_user_with_api_key
  before_filter :authenticate_user!
  protect_from_forgery

  helper :all
  before_filter :init_user_profile  #!!!! delete move to registrations and create on registration
  before_filter :make_current_online
  helper_method :current_company
  include ApplicationHelper

  
  def sign_in_user_with_api_key
    unless params[:token].blank?
      # find token. Check if valid.
      user_token = params[:token]
      token = ApiKey.where(:access_token => user_token).first
      if token && !token.expired?
        @current_user = User.find(token.user_id)
        sign_in(@current_user)
      end
    end   
  end

  def current_company
    if user_signed_in?
      current_user.company
    end
  end

  def init_user_profile
    if user_signed_in?
      unless current_user.user_profile
        user_profile = UserProfile.create!
        current_user.user_profile = user_profile
        current_user.save!
      end
    end
  end

private
  def make_current_online
    current_user.go_online if user_signed_in?
  end

end
