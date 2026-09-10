require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:member)
  end

  test "shows the signed-in user's profile" do
    get profile_path
    assert_response :success
    assert_equal "Profile/Show", inertia.component
    assert_equal users(:member).id, inertia.props.dig(:user, :id)
  end

  test "updates the signed-in user's profile" do
    patch profile_path, params: {
      user: {
        full_name: "Morgan Updated",
        email_address: users(:member).email_address
      }
    }

    assert_redirected_to profile_path
    assert_equal "Morgan Updated", users(:member).reload.full_name
  end

  test "does not allow members to change their role" do
    assert_raises ActionController::UnpermittedParameters do
      patch profile_path, params: {
        user: {
          full_name: users(:member).full_name,
          email_address: users(:member).email_address,
          role: "admin"
        }
      }
    end
  end

  test "deletes the signed-in user's account" do
    assert_difference("User.count", -1) do
      delete profile_path
    end

    assert_redirected_to register_path
  end
end
