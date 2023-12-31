Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get 'pages/home'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
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
      get 'manual', to: 'pages#under_construction'
      get 'badge', to: 'pages#under_construction'
      get 'parents_dashboard'
      post 'exchange_reward'
      post 'reset_task'
    end

    member do
      put 'choose'
      put 'mark_complete'
      put 'cancel_task'
    end
  end

  resources :parents, only: [] do
    collection do
      get 'new_child', to: 'parents#new_child'
      post 'create_child', to: 'parents#create_child'
      get 'dashboard'
      delete 'destroy_child/:id', to: 'parents#destroy_child', as: 'destroy_child'
    end
  end

  get 'role_selection', to: 'role_selection#index' # 役割選択ページのルーティングを変更

  root 'pages#home'

  mount LetterOpenerWeb::Engine, at: '/letter_opener_web' if Rails.env.development?
end
