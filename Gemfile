source "https://rubygems.org"

ruby "4.0.6"

gem "rails", "~> 8.1.3", ">= 8.1.3.1"
gem "propshaft"
gem "pg", "~> 1.1"
gem "sqlite3", ">= 2.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "bcrypt", "~> 3.1"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false
gem "image_processing", "~> 1.2"
gem "inertia_rails", "~> 3.22"
gem "vite_rails", "~> 3.11"
gem "roo", "~> 3.0"
gem "active_model_serializers", "~> 0.10"
gem "rails-i18n", "~> 8.0"

group :development, :test do
  gem "rspec-rails", "~> 8.0"
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "bundler-audit", require: false
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "simplecov", require: false
end
