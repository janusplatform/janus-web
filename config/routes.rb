require 'sidekiq/web'

Rails.application.routes.draw do

  devise_for :users

  root 'desktop#index'


  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

end
