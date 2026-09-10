require "application_system_test_case"

class AdminUsersSystemTest < ApplicationSystemTestCase
  setup do
    sign_in "admin@example.com"
  end

  test "admin can create a user from the dashboard" do
    click_link I18n.t("frontend.dashboard.create_user")
    fill_in "full_name", with: "Dashboard User"
    fill_in "email_address", with: "dashboard.user@example.com"
    fill_in "password", with: "password123"
    fill_in "password_confirmation", with: "password123"
    click_button I18n.t("frontend.forms.create_user")

    assert_text "Dashboard User"
    assert_text "dashboard.user@example.com"
  end

  test "admin can toggle a member role" do
    within(:xpath, "//tr[contains(., 'Morgan Member')]") do
      click_button I18n.t("frontend.dashboard.toggle_role")
    end

    assert_text I18n.t("frontend.roles.admin")
  end
end
