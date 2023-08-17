Rails.application.routes.draw do
  devise_for :users
  resources :tasks
  root 'tasks#index'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener_web"
  end
end
