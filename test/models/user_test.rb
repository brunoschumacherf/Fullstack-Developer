require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @admin = users(:admin)
    @member = users(:member)
  end

  test "accepts a valid user" do
    user = User.new(
      full_name: "Casey New",
      email_address: "casey@example.com",
      password: "password123",
      password_confirmation: "password123",
      role: :member
    )

    assert user.valid?
  end

  test "requires full name, email, and password" do
    user = User.new
    assert_not user.valid?
    assert_includes user.errors[:full_name], I18n.t("errors.messages.blank")
    assert_includes user.errors[:email_address], I18n.t("errors.messages.blank")
    assert_includes user.errors[:password], I18n.t("errors.messages.blank")
  end

  test "rejects invalid emails" do
    user = User.new(full_name: "Casey", email_address: "not-an-email", password: "password123")
    assert_not user.valid?
    assert user.errors[:email_address].present?
  end

  test "enforces unique emails" do
    user = User.new(
      full_name: "Copy",
      email_address: @member.email_address,
      password: "password123"
    )

    assert_not user.valid?
    assert_includes user.errors[:email_address], I18n.t("errors.messages.taken")
  end

  test "defaults new users to member" do
    user = User.create!(
      full_name: "Default Role",
      email_address: "default.role@example.com",
      password: "password123"
    )

    assert user.member?
  end

  test "rejects invalid avatar urls" do
    @member.avatar_url = "ftp://example.com/avatar.png"
    assert_not @member.valid?
  end

  test "prevents demoting the last remaining admin" do
    users(:second_admin).destroy!
    @admin.role = :member

    assert_not @admin.valid?
    assert_includes @admin.errors[:role], I18n.t("activerecord.errors.models.user.attributes.role.last_admin")
  end

  test "prevents deleting the last remaining admin" do
    users(:second_admin).destroy!

    assert_no_difference("User.count") do
      @admin.destroy
    end
    assert_includes @admin.errors[:base], I18n.t("activerecord.errors.models.user.attributes.base.last_admin")
  end

  test "serializes props with an avatar fallback" do
    user = User.create!(
      full_name: "No Avatar",
      email_address: "no.avatar@example.com",
      password: "password123",
      avatar_url: nil
    )

    assert_equal user.id, user.to_props[:id]
    assert_includes user.avatar_image_url, "ui-avatars.com"
  end

  test "encrypts email addresses at rest" do
    raw = User.connection.select_value(
      User.sanitize_sql_array(["SELECT email_address FROM users WHERE id = ?", @member.id])
    )

    assert_not_equal @member.email_address, raw
  end
end
