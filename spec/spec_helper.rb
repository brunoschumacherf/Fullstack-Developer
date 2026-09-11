require "simplecov"

SimpleCov.start "rails" do
  enable_coverage :branch
  skip %r{^/config/}
  skip %r{^/db/}
  skip %r{^/vendor/}
  skip %r{^/bin/}
  skip %r{^/spec/}
  skip %r{^/lib/tasks/}
  group "Services", "app/services"
  group "Channels", "app/channels"
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
