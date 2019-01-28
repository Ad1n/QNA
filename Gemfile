source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

#UI
gem 'jquery-rails'
gem 'bootstrap', '~> 4.1.3'


# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

gem 'slim-rails'
gem 'devise'

#Attach files
gem 'carrierwave'

# Create objects with adding files by AJAX
gem 'remotipart'
# Add several files to object
gem 'cocoon'

# Templates for client side
gem 'skim'
gem 'sprockets', '>= 3.7.0'

# Get instance variable to JS template
gem 'gon'

# For thin controllers
gem 'responders', '~> 2.0'

gem 'omniauth'
gem 'omniauth-vkontakte'
gem 'omniauth-facebook'
gem 'omniauth-github'

# Rails authorization
gem 'cancancan'

# Oauth provider maker
gem 'doorkeeper', '4.2.6'

# Json creater
gem "active_model_serializers"

# Json parser
gem "oj"
gem "oj_mimic_json"

# Sheduled tasks
gem "whenever"
gem "sidekiq"
gem "sinatra", ">= 1.3.0", require: nil
gem "sidetiq"

# Full text search
gem 'mysql2',          '~> 0.3',    :platform => :ruby
gem 'thinking-sphinx', '~> 4.0'

# Console
gem 'rb-readline'

# Java for assets compiller in production
gem "mini_racer"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'database_cleaner'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'fuubar'
  gem 'rails-controller-testing'
  gem 'webdrivers'
  gem 'capybara', '>= 2.15'
  # gem 'capybara-webkit', github: 'thoughtbot/capybara-webkit', branch: 'master'
  gem 'capybara-email'

  #Create models with tables in RSpec tests
  gem 'with_model'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem "letter_opener"

  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano-websocket-rails', require: false
end

group :test do

  # Easy installation and use of chromedriver to run system tests with Chrome
  gem "selenium-webdriver"
  gem 'chromedriver-helper'

  gem 'shoulda-matchers', '4.0.0.rc1'
  gem 'rails-controller-testing' # If you are using Rails 5.x
  gem 'launchy'
  gem 'json_spec'
  gem 'rspec-sidekiq'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
