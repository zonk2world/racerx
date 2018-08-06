== README

This README would normally document whatever steps are necessary to get the
application up and running.

* Ruby version
  Ruby 2.0.0-p353

* Rails version
  Rails 4.0.2

* System dependencies

* Configuration

* Database creation
  rake db:create

* Database initialization
  rake db:migrate
  rake db:seed

  OR 
  
  curl -o latest.dump `heroku pgbackups:url --app motodynasty`   
  pg_restore --verbose --clean --no-acl --no-owner -h localhost -U 12spokes -d MotoDynasty_development latest.dump

* How to run the test suite
  bundle exec rspec spec/
  bundle exec cucumber features

* Services (job queues, cache servers, search engines, etc.)
  make sure to set .rbenv-vars
  STRIPE_PUBLISHABLE_KEY=blah
  STRIPE_SECRET_KEY=blah
  DEVISE_SECRET_TOKEN=blah
  
* Convert html 2 slim
  rake convert:erb_to:slim

* Deployment instructions
