require "test_helper"

class SecurityTest < ActionDispatch::IntegrationTest
  test "escapes stored xss payloads in inertia props" do
    payload = "<script>alert('xss')</script>"
    users(:member).update!(full_name: payload)
    sign_in_as users(:member)
    get profile_path

    assert_no_match(%r{<script>alert\('xss'\)</script>}, response.body)
  end

  test "does not interpolate sql from user identifiers" do
    sign_in_as users(:admin)

    assert_raises ActiveRecord::RecordNotFound do
      get edit_admin_user_path("1 OR 1=1")
    end
  end

  test "rejects state-changing login without a csrf token" do
    with_forgery_protection do
      assert_raises ActionController::InvalidAuthenticityToken do
        post login_path, params: {
          email_address: users(:admin).email_address,
          password: "password123"
        }
      end
    end
  end

  test "does not expose encrypted emails as plaintext in sql" do
    raw = User.connection.select_value(
      User.sanitize_sql_array(["SELECT email_address FROM users WHERE id = ?", users(:admin).id])
    )

    assert_not_includes raw.to_s, "admin@example.com"
  end

  private

  def with_forgery_protection
    old = ActionController::Base.allow_forgery_protection
    ActionController::Base.allow_forgery_protection = true
    yield
  ensure
    ActionController::Base.allow_forgery_protection = old
  end
end
