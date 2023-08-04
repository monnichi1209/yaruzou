Rails.application.routes.draw do
  root 'blogs#index'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener_web"
  end
end
