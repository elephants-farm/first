module Auth
  class RegistrationsController < Devise::RegistrationsController
    

    def new
      build_resource({})
      #respond_with self.resource
      render 'home/index'
    end
    
    def create
      company_name = params[:user].delete(:company_name)

      build_resource(sign_up_params)

      if resource.save
        resource.company = Company.create(name: company_name.blank? ? 'untitled company' : company_name)

        if resource.active_for_authentication?
          set_flash_message :notice, :signed_up if is_navigational_format?
          sign_up(resource_name, resource)
          respond_with resource, :location => after_sign_up_path_for(resource)
        else
          set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
          expire_session_data_after_sign_in!
          respond_with resource, :location => after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        #respond_with resource
        render 'home/index'
      end
    end

    def edit
      super
    end
    
    def update
      super
    end
    
    def destroy
      super
    end

    def cancel
      super
    end
  protected

  end
end