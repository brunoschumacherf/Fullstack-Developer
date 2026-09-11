require "rails_helper"

RSpec.describe "Security", type: :request do
  around do |example|
    previous = Rails.application.env_config["action_dispatch.show_exceptions"]
    Rails.application.env_config["action_dispatch.show_exceptions"] = :none
    example.run
  ensure
    Rails.application.env_config["action_dispatch.show_exceptions"] = previous
  end

  it "escapes stored xss payloads in inertia props" do
    payload = "<script>alert('xss')</script>"
    users(:member).update!(full_name: payload)
    sign_in_as users(:member)
    get profile_path

    expect(response.body).not_to match(%r{<script>alert\('xss'\)</script>})
  end

  it "does not interpolate sql from user identifiers" do
    sign_in_as users(:admin)

    expect do
      get edit_admin_user_path("1 OR 1=1")
    end.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "rejects state-changing login without a csrf token" do
    with_forgery_protection do
      expect do
        post login_path, params: {
          email_address: users(:admin).email_address,
          password: "password123"
        }
      end.to raise_error(ActionController::InvalidAuthenticityToken)
    end
  end

  it "does not expose encrypted emails as plaintext in sql" do
    raw = User.connection.select_value(
      User.sanitize_sql_array([ "SELECT email_address FROM users WHERE id = ?", users(:admin).id ])
    )

    expect(raw.to_s).not_to include("admin@example.com")
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
