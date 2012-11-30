source 'https://rubygems.org'
ruby '1.8.7'
gem 'rails', '3.2.8'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

#In development we use mysql
group :development do
  gem 'mysql'
end

#In production (heroku) PostgreSQL
group :production do
  gem 'pg'
  gem 'mysql'
end

gem 'json'
#gem 'activeresource', :require => 'active_resource'
gem 'rest-client'
gem 'rake'
gem 'highcharts-rails', '~> 2.3.3'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'bootstrap-sass', '2.1.0.1'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :test,:development do 
  gem 'rspec-rails'
end

group :test do
  gem 'capybara', '1.1.2'
end

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'heroku'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'
