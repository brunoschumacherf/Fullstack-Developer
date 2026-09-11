require "simplecov"

SimpleCov.start "rails" do
  enable_coverage :branch
  add_filter %r{^/config/}
  add_filter %r{^/db/}
  add_filter %r{^/vendor/}
  add_filter %r{^/bin/}
  add_filter %r{^/spec/}
  add_filter %r{^/lib/tasks/}
  add_group "Services", "app/services"
  add_group "Channels", "app/channels"
  minimum_coverage line: 90, branch: 90
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.order = :random
  Kernel.srand config.seed
end
