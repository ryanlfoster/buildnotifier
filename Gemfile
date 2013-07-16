source "https://rubygems.org"
ruby "2.0.0"

gem 'rails', '~> 3.2.12'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'


# Use unicorn as the web server
gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19', :require => 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
gem 'haml'
gem "haml-rails"
gem "jquery-rails"
gem "bson_ext"
gem "mongoid", "~> 3.0.0"
gem "sass"
gem "barista"
gem "heroku"

group :production do
  # gem 'therubyracer-heroku'
end

group :development do
  gem 'pry'
end

gem "aws-sdk"
gem "aws-s3", :require => "aws/s3"
gem "mongoid-paperclip", :require => "mongoid_paperclip"
gem "omniauth"
gem 'omniauth-identity'
gem "paperclip"
gem 'CFPropertyList'
gem 'acts_as_list_mongoid'
gem 'libxml-ruby'
gem 'mails_viewer', :git => 'http://github.com/tomlion/mails_viewer.git'
gem 'mongoid_slug'
gem 'bcrypt-ruby'
gem 'rdiscount'
gem 'rubyzip'
gem 'gravatar-ultimate'

gem 'cancan'
gem 'rolify'

gem "twitter-bootstrap-rails"
gem 'simple_form'

gem 'settingslogic'

group :development, :test do
  gem 'rspec-rails', '~> 2.0'
  gem 'steak'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'faker'
  gem 'guard'
  gem 'guard-rspec'
end

group :test do
	gem 'pg'
  gem 'shoulda-matchers'
  gem 'mongoid-rspec'
  gem 'simplecov', :require => false
end

group :linux_development do
  gem 'rb-inotify'
  gem 'libnotify'
end

group :mac_development do
  gem 'rb-fsevent'
end
