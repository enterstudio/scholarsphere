source 'https://rubygems.org'

# Ruby on Rails components
gem 'rails', '4.2.7.1'
gem 'mysql2', '~> 0.3.17' unless ENV['CI']

# Hydra community components
gem 'browse-everything', github: 'projecthydra/browse-everything', ref: '518d905'
gem 'fedora-migrate', github: 'projecthydra-labs/fedora-migrate', ref: '85dd700df3b3195bceea6b988ec70bb2b82bd282'
gem 'hydra-derivatives', '1.2.1'
gem 'hydra-head', '~> 9.5.0'
gem 'hydra-ldap', '0.1.0'
gem 'sufia', github: 'projecthydra/sufia', ref: 'f61c5d64e'
gem 'blacklight', '5.18.0'
gem 'redis', '3.2.0'
gem 'active-fedora', '9.7.3'
gem 'rake', '11.3.0'

# sprockets-rails 3 is complaining about images not being precompiled. 
gem 'sprockets-rails', '< 3.0.0'

# Other components
gem 'clamav' unless ENV['TRAVIS'] == 'true'
gem 'coffee-rails'
gem 'devise', '~> 3.5'
gem 'jbuilder', '~> 2.0'
gem 'jquery-rails', '~> 3.1'
gem 'kaminari', github: 'jcoyne/kaminari', branch: 'sufia'
gem 'namae', '0.9.3'
gem 'nest'
gem 'newrelic_rpm'
gem 'rack-maintenance'
gem 'rainbow'
gem 'resque-pool'
gem 'rsolr'
gem 'sass-rails'
gem 'select2-rails'
gem 'share_notify'
gem 'sitemap'
gem 'therubyracer'
gem 'uglifier'
gem 'whenever'
gem 'yaml_db'
gem 'ldap_disambiguate'

group :development, :test do
  gem 'jettywrapper'
  gem 'rspec-its'
  gem 'rspec-rails'
  gem 'rubocop', '~> 0.39.0'
  gem 'rubocop-rspec', '~> 1.4.1'
  gem 'sqlite3'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'

# Use Capistrano for deployment
  gem 'capistrano', '~> 3.7', require: false
  gem 'capistrano-bundler', '~> 1.2',require: false
  gem 'capistrano-rails', '~> 1.2', require: false
  gem 'capistrano-rbenv', '~> 2.1', require: false
  gem 'capistrano-rbenv-install'
  gem 'capistrano-resque', '~> 0.2.1', require: false

  gem 'unicorn-rails'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'equivalent-xml'
  gem 'factory_girl_rails', '~> 4.1'
  gem 'fuubar'
  gem 'poltergeist', '~> 1.9'
  gem 'rspec-activemodel-mocks'
  gem 'vcr'
  gem 'webmock'
end

group :debug do
  gem 'byebug', require: false
  gem 'capybara-screenshot'
  gem 'launchy'
end

