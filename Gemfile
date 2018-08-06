source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '4.0.2'
gem 'pg'
gem 'sass-rails', '4.0.2'
gem 'bootstrap-sass', '3.2.0.2'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 1.2'
gem 'devise'
gem 'factory_girl_rails', '~> 4.0'
gem 'slim'
gem 'rails_admin', '0.6.0'
gem 'cancan'
gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'
gem 'html2slim'
gem 'activerecord-postgres-hstore'
gem "ransack" 
gem 'airbrake', '~>3.1.14'

gem 'delayed_job_active_record'
gem 'newrelic_rpm'
gem 'letter_opener_web', '~> 1.1.0', :group => :development

# facebook graph api
gem 'omniauth'
gem 'omniauth-facebook'
gem 'koala'

group :doc do
  gem 'sdoc', require: false
end

group :development, :test do
  gem 'active_record_query_trace'
  gem 'rspec-rails', '~> 3.0.0.beta'
  gem 'pry'
  gem 'byebug'
end

group :development do
  gem 'guard-rspec', :require => false
  gem 'terminal-notifier-guard', :require => false
end

group :test do
  gem 'selenium-webdriver'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'launchy'
  gem 'webmock', '~> 1.8.0', :require => false
  gem 'vcr', :require => false
end

group :production do
  gem 'rails_12factor'
end
# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
