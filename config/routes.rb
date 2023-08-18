Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get 'pages/home'
  
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  # devise_scopeを追加
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
    post 'users/admin_guest_sign_in', to: 'users/sessions#admin_guest_sign_in'
  end

  resources :tasks do
    collection do
      get 'tasks_for_kids'
      get 'rewards'
    end
  end

  root 'pages#home'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener_web"
  end
end
