Rails.application.routes.draw do
  get 'pages/home'
  devise_for :users
  resources :tasks
  root 'pages#home'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener_web"
  end
end
