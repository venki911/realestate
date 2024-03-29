source 'https://rubygems.org'

ruby '2.2.0'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use mysql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
gem 'active_model_serializers'

gem 'email_validator'
gem "koala", "~> 1.11.0rc"
gem "simple_form"
gem "kaminari"

gem "carrierwave"
gem 'carrierwave-aws' #using amazon aws-sdk is more featured than fog

gem "mini_magick"
gem 'bootstrap-sass', '~> 3.3.3'
gem "jquery-fileupload-rails"
gem "rails-timeago"
gem "font-awesome-rails"
gem 'bootsy'

gem 'sidekiq'
gem 'sinatra', :require => nil

gem "fog", "~>1.20", require: "fog/aws/storage"
gem 'asset_sync'

group :development do
  gem 'capistrano', '~> 3.3.0'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano-passenger'

  gem 'better_errors'
  gem 'brakeman'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'factory_girl_rails'
  gem 'pry-rails'
  
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'spring-commands-rspec'

end

group :production do
  gem 'rails_12factor'
  # gem 'puma'
end

group :test do
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'faker'
  gem 'launchy'
  gem 'simplecov', require: false
  gem 'capybara'
  gem "codeclimate-test-reporter", require: nil
end

