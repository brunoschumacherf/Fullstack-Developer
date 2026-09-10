require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "renders registration for visitors" do
    get register_path
    assert_response :success
    assert_equal "Auth/Register", inertia.component
  end

  test "creates a member account and signs the visitor in" do
    assert_difference("User.count", 1) do
      post register_path, params: {
        user: {
          full_name: "Visitor Person",
          email_address: "visitor@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    user = User.find_by(email_address: "visitor@example.com")
    assert user.member?
    assert_redirected_to profile_path
  end

  test "does not allow visitors to register as admin" do
    assert_raises ActionController::UnpermittedParameters do
      post register_path, params: {
        user: {
          full_name: "Evil Visitor",
          email_address: "evil@example.com",
          password: "password123",
          password_confirmation: "password123",
          role: "admin"
        }
      }
    end
  end

  test "returns validation errors for duplicate emails" do
    post register_path, params: {
      user: {
        full_name: "Dup",
        email_address: users(:member).email_address,
        password: "password123",
        password_confirmation: "password123"
      }
    }

    assert_redirected_to register_path
  end
end
