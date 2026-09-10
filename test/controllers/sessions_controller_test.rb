require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "renders the login page for visitors" do
    get login_path
    assert_response :success
    assert_equal "Auth/Login", inertia.component
  end

  test "redirects admins to the dashboard after login" do
    post login_path, params: { email_address: users(:admin).email_address, password: "password123" }

    assert_redirected_to admin_dashboard_path
  end

  test "redirects members to their profile after login" do
    post login_path, params: { email_address: users(:member).email_address, password: "password123" }

    assert_redirected_to profile_path
  end

  test "rejects invalid credentials" do
    post login_path, params: { email_address: users(:admin).email_address, password: "wrong-password" }

    assert_redirected_to login_path
    follow_redirect!
    assert_equal I18n.t("flashes.sessions.invalid"), flash[:alert]
  end

  test "signs the user out" do
    sign_in_as users(:member)
    delete logout_path

    assert_redirected_to login_path
    get profile_path
    assert_redirected_to login_path
  end
end
