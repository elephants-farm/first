class UserProfilesController < ApplicationController

  def show
    @user_profile = current_user.user_profile
  end
  def edit
    @user_profile = current_user.user_profile
  end

  def update
    @user_profile = current_user.user_profile

    
    respond_to do |format|
      if @user_profile.update_attributes(params[:user_profile])
        format.html { redirect_to(@user_profile, :notice => 'Profile was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end
end