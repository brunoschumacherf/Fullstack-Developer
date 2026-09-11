require "rails_helper"

RSpec.describe "Profile", type: :system do
  it "member can update their own profile" do
    sign_in "user@example.com"
    fill_in "full_name", with: "Morgan Profile"
    click_button I18n.t("frontend.forms.save_changes")

    expect(page).to have_text("Morgan Profile")
  end
end
