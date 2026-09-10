require "test_helper"

module Admin
  class UsersControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as users(:admin)
    end

    test "lists users through the dashboard" do
      get admin_users_path
      assert_redirected_to admin_dashboard_path
    end

    test "creates a user" do
      assert_difference("User.count", 1) do
        post admin_users_path, params: {
          user: {
            full_name: "Created User",
            email_address: "created@example.com",
            password: "password123",
            password_confirmation: "password123",
            role: "member"
          }
        }
      end

      assert_redirected_to admin_dashboard_path
    end

    test "updates a user" do
      patch admin_user_path(users(:member)), params: {
        user: {
          full_name: "Morgan Edited",
          email_address: users(:member).email_address,
          role: "member"
        }
      }

      assert_redirected_to admin_dashboard_path
      assert_equal "Morgan Edited", users(:member).reload.full_name
    end

    test "toggles a user role" do
      patch admin_user_path(users(:member)), params: { user: { role: "admin" } }

      assert users(:member).reload.admin?
    end

    test "deletes a member" do
      assert_difference("User.count", -1) do
        delete admin_user_path(users(:member))
      end
    end

    test "members cannot manage users" do
      delete logout_path
      sign_in_as users(:member)

      get new_admin_user_path
      assert_redirected_to profile_path
    end
  end
end
