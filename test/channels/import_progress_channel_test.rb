require "test_helper"

class ImportProgressChannelTest < ActionCable::Channel::TestCase
  setup do
    @import = users(:admin).user_imports.new
    @import.file.attach(
      io: file_fixture("users.csv").open,
      filename: "users.csv",
      content_type: "text/csv"
    )
    @import.save!
  end

  test "admins can subscribe to an import stream" do
    stub_connection current_user: users(:admin)
    subscribe id: @import.id

    assert subscription.confirmed?
    assert_has_stream "import_progress_#{@import.id}"
  end

  test "members are rejected" do
    stub_connection current_user: users(:member)
    subscribe id: @import.id
    assert subscription.rejected?
  end

  test "unknown imports are rejected" do
    stub_connection current_user: users(:admin)
    subscribe id: 0
    assert subscription.rejected?
  end
end
