ENV["RAILS_ENV"] ||= "test"
require "simplecov"

SimpleCov.start "rails" do
  enable_coverage :branch
  add_filter %r{^/config/}
  add_filter %r{^/db/}
  add_filter %r{^/vendor/}
  add_filter %r{^/bin/}
  add_filter %r{^/test/}
  add_filter %r{^/lib/tasks/}
  add_group "Services", "app/services"
  add_group "Channels", "app/channels"
  minimum_coverage line: 90
end

require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)
    parallelize_setup do |worker|
      SimpleCov.command_name "#{SimpleCov.command_name}-#{worker}"
    end
    parallelize_teardown do |_worker|
      SimpleCov.result
    end

    fixtures :all

    def sign_in_as(user, password: "password123")
      post login_path, params: { email_address: user.email_address, password: password }
    end
  end
end

module ActionDispatch
  class IntegrationTest
    def sign_in_as(user, password: "password123")
      post login_path, params: { email_address: user.email_address, password: password }
    end
  end
end
