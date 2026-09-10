require "test_helper"

class ApplicationCable::ConnectionTest < ActionCable::Connection::TestCase
  test "connects with a signed session cookie" do
    cookies.signed[:session_id] = sessions(:admin).id

    connect
    assert_equal users(:admin), connection.current_user
  end

  test "rejects connections without a session" do
    assert_reject_connection { connect }
  end
end
