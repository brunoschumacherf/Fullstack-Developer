abort("Cannot run specs in production!") if ENV["RAILS_ENV"] == "production"
ENV["RAILS_ENV"] = "test"
require "spec_helper"
require_relative "../config/environment"
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"
require "inertia_rails/rspec"

ActiveRecord::Migration.maintain_test_schema!

module RequestAuthenticationHelpers
  def sign_in_as(user, password: "password123")
    post login_path, params: { email_address: user.email_address, password: password }
  end
end

module SystemAuthenticationHelpers
  def sign_in(email, password = "password123")
    visit login_path
    fill_in "email_address", with: email
    fill_in "password", with: password
    click_button I18n.t("frontend.login.submit")
  end
end

RSpec.configure do |config|
  config.fixture_paths = [ Rails.root.join("spec/fixtures") ]
  config.file_fixture_path = Rails.root.join("spec/fixtures/files")
  config.global_fixtures = :all
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include RequestAuthenticationHelpers, type: :request
  config.include SystemAuthenticationHelpers, type: :system
  config.include RSpec::Rails::RailsExampleGroup, type: :service
  config.include RSpec::Rails::RailsExampleGroup, type: :query
  config.include RSpec::Rails::RailsExampleGroup, type: :serializer

  config.before(:each, type: :system) do
    driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ] do |options|
      options.binary = ENV["CHROME_BIN"] if ENV["CHROME_BIN"]
      if File.exist?("/.dockerenv")
        options.add_argument("--no-sandbox")
        options.add_argument("--disable-dev-shm-usage")
      end
    end
  end
end
