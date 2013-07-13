require File.expand_path('../boot', __FILE__)
require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module ElephantFarm
  class Application < Rails::Application
    config.generators do |g|
        g.template_engine :haml
    end
    
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**}')]
    
    config.filter_parameters += [:password]
    

    I18n.default_locale = :en
    OmniAuth.config.logger = Logger.new(STDOUT)
    OmniAuth.logger.progname = "omniauth"
    
    config.assets.enabled = true

    config.assets.version = '1.2'
    manifest_files = Dir["#{Rails.root.join('app', 'assets').to_s}/*/*_manifest.*"].map { |path| File.basename(path) }

    config.assets.precompile += manifest_files
    config.assets.compress = true
    config.assets.compile = true
    config.to_prepare do
      Devise::SessionsController.layout "devise"
      Devise::RegistrationsController.layout proc{ |controller| user_signed_in? ? "application"   : "devise" }
      Devise::ConfirmationsController.layout "devise"
      Devise::UnlocksController.layout "devise"            
      Devise::PasswordsController.layout "devise"        
    end
  end
end

