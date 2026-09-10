require "application_system_test_case"

class ProfileSystemTest < ApplicationSystemTestCase
  test "member can update their own profile" do
    sign_in "user@example.com"
    fill_in "full_name", with: "Morgan Profile"
    click_button I18n.t("frontend.forms.save_changes")

    assert_text "Morgan Profile"
  end
end
