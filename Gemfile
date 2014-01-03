source 'https://rubygems.org'

gem 'bundler'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rake'
gem 'rails', '4.0.2'
gem 'foreman', '0.63.0'

gem 'devise'

gem 'rack-cache'
gem 'redis-rails'

if ENV['crypto_trader_local']
  gem 'crypto_trader', :path => '../crypto_trader/'
else
  gem 'crypto_trader', :git => 'git@github.com:boymaas/crypto_trader.git', :branch => :master
end

# asset gems
gem 'bootstrap-slider-rails'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'
gem 'sequel'
gem 'pg'
gem 'kaminari'
gem 'jquery-datatables-rails', git: 'git://github.com/rweng/jquery-datatables-rails.git'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

gem 'mina'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem "haml"
gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem "twitter-bootstrap-rails", :git => 'https://github.com/seyhunak/twitter-bootstrap-rails.git', :branch => 'bootstrap3'


group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end



# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
group :development, :test do
  gem 'require_reloader'
  gem 'html2haml'
  gem 'rspec-rails'
  gem 'byebug'
  gem 'pry'
end
# gem 'debugger', group: [:development, :test]
