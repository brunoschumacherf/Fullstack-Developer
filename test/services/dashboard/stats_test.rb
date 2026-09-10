require "test_helper"

module Dashboard
  class StatsTest < ActiveSupport::TestCase
    test "counts users by role" do
      stats = Dashboard::Stats.call

      assert_equal User.count, stats[:total_users]
      assert_equal User.admin.count, stats[:role_counts]["admin"]
      assert_equal User.member.count, stats[:role_counts]["member"]
    end
  end
end
