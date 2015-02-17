source "https://rubygems.org"
ruby "2.1.2"

gem "rails", "4.1.4"

gem "sass-rails", "~> 4.0.2"
gem "coffee-rails", "~> 4.0.0"
gem "jquery-rails", "~> 3.1.1"
gem "jquery-ui-rails", "~> 4.2.1"
gem "bootstrap-sass", "~> 3.1.1"
gem "font-awesome-rails"
gem "uglifier", ">= 1.3.0"
gem "slim-rails", "~> 2.1.3"

gem "will_paginate", "~> 3.0"
gem "bootstrap-will_paginate"

gem "devise", "3.3.0"
gem "cancancan", "1.9.2"

gem "active_model_serializers", "0.9.0"

gem "pg", "0.17.1"

gem "travis", github: "travis-ci/travis.rb"

# Search
gem "pg_search", "~> 0.7.8"

# Uploads
gem "carrierwave", "~> 0.10.0"
gem "fog", "~> 1.22.1"
gem "rmagick", "~> 2.13.2", require: false

# Seeding Data
gem "faker", "~> 1.4.3"

group :development, :test do
  gem "annotate", "~> 2.6.1"
  gem "awesome_print", "~> 1.2.0"
  gem "better_errors", "~> 1.1.0"
  gem "binding_of_caller", "~> 0.7.2"
  gem "bullet", "~> 4.8.0"
  gem "commands", "~> 0.2.1"
  gem "factory_girl_rails", "~> 4.4.0"
  gem "rails_best_practices", "~> 1.15.1"
  gem "rspec-rails", "~> 2.14.1"
  gem "quiet_assets", "~> 1.0.2"
  gem "guard"
  gem "guard-livereload"
  gem "guard-rspec"
  gem "pry-rails"
end

group :test do
  gem "database_cleaner"
end

group :production do
  gem "rails_12factor"

  # TODO(mark): Uncomment when we install new relic
  gem "newrelic_rpm"
end

