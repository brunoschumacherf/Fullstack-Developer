require "test_helper"

class DashboardChannelTest < ActionCable::Channel::TestCase
  test "admins can subscribe" do
    stub_connection current_user: users(:admin)
    subscribe
    assert subscription.confirmed?
    assert_has_stream Dashboard::Broadcaster::STATS_STREAM
  end

  test "members are rejected" do
    stub_connection current_user: users(:member)
    subscribe
    assert subscription.rejected?
  end
end
