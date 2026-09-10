require "test_helper"

module Admin
  class DashboardControllerTest < ActionDispatch::IntegrationTest
    test "admins can open the dashboard" do
      sign_in_as users(:admin)
      get admin_dashboard_path

      assert_response :success
      assert_equal "Admin/Dashboard", inertia.component
      assert inertia.props[:stats][:total_users] >= 3
      assert inertia.props[:users].is_a?(Array)
    end

    test "members are blocked from the dashboard" do
      sign_in_as users(:member)
      get admin_dashboard_path

      assert_redirected_to profile_path
    end

    test "visitors are sent to login" do
      get admin_dashboard_path
      assert_redirected_to login_path
    end
  end
end
