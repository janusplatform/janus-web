require 'sidekiq/web'

Rails.application.routes.draw do

  devise_for :users

  root 'desktop#index'

  resources :desktop do
    collection do
      get :guest
    end
  end


  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

end
