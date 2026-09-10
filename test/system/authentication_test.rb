require "application_system_test_case"

class AuthenticationSystemTest < ApplicationSystemTestCase
  test "admin lands on the dashboard after login" do
    sign_in "admin@example.com"
    assert_text I18n.t("frontend.dashboard.title")
    assert_text I18n.t("frontend.dashboard.total_users")
    assert_text "Ada Admin"
  end

  test "member lands on their profile after login" do
    sign_in "user@example.com"
    assert_text "Morgan Member"
    assert_text I18n.t("frontend.profile.edit_title")
    assert_no_text I18n.t("frontend.dashboard.title")
  end

  test "visitor can register as a member" do
    visit register_path
    fill_in "full_name", with: "New Visitor"
    fill_in "email_address", with: "new.visitor@example.com"
    fill_in "password", with: "password123"
    fill_in "password_confirmation", with: "password123"
    click_button I18n.t("frontend.forms.create_account")

    assert_text "New Visitor"
    assert_text I18n.t("frontend.profile.edit_title")
  end
end
