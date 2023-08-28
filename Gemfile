source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.1'

gem 'bootsnap', '>= 1.4.4', require: false
gem 'bootstrap-sass'
gem 'cancancan'
gem 'devise'
gem 'devise-i18n'
gem 'dotenv-rails' # 開発環境で環境変数を操作するのに必要
gem 'jbuilder', '~> 2.7'
gem 'jquery-rails'
gem 'kaminari'
gem 'kaminari-bootstrap'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 6.1.7', '>= 6.1.7.4'
gem 'rails_admin'
gem 'rails_admin-i18n' # rails_adminの日本語化のためのgem
gem 'rails-i18n', '~> 6.0' # Railsの基本的な日本語化のためのgem
gem 'rexml'
gem 'sass-rails', '>= 6'
gem 'simple_form'
gem 'turbolinks', '~> 5'
gem 'unicorn' # アプリケーションサーバのunicorn
gem 'webpacker', '~> 5.0'

group :development, :test do
  gem 'bcrypt_pbkdf'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capistrano', '3.16.0' # capistranoのツール一式
  gem 'capistrano3-unicorn'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'ed25519'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'launchy'
  gem 'rspec-rails'
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :development do
  gem 'letter_opener_web'
  gem 'listen', '~> 3.3'
  gem 'pry-rails'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'rubocop', require: false
  gem 'spring'
  gem 'web-console', '>= 4.1.0'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver', '>= 4.0.0.rc1'
  gem 'webdrivers'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
