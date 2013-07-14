ElephantFarm::Application.routes.draw do
  devise_for :users, :controllers => {:sessions => "auth/sessions", :registrations => "auth/registrations"}
  get :access_denied, to: 'home#access_denied'

  resources :uploads

  resources :companies, only: [:edit, :update] do
  end

  resources :users do
    member do
      get :fetch_tasks
      get 'my_tasks/:project_id', to: 'users#my_tasks'    #go to projectsk

    end
  end

  resources :user_profiles, only: [:show, :update, :edit]

  resources :tags, only: [:index] do
    member do
      get :fetch_tasks
    end
  end

  resources :projects do
    get :employees
    member do
      post :fetch_tasks
    end
    resources :tasks, :only => [:create, :index, :update] do
      member do
        get :fetch_uploads
        get :fetch_comments
        post :new_comment
      end
    end
  end
  
  root to: 'home#index'

  ########################## API #########################
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :tasks, :only => [:create]
    end
  end
end
