require "rails_helper"

RSpec.describe "Authentication", type: :system do
  it "admin lands on the dashboard after login" do
    sign_in "admin@example.com"
    expect(page).to have_text(I18n.t("frontend.dashboard.title"))
    expect(page).to have_text(I18n.t("frontend.dashboard.total_users"))
    expect(page).to have_text("Ada Admin")
  end

  it "member lands on their profile after login" do
    sign_in "user@example.com"
    expect(page).to have_text("Morgan Member")
    expect(page).to have_text(I18n.t("frontend.profile.edit_title"))
    expect(page).not_to have_text(I18n.t("frontend.dashboard.title"))
  end

  it "visitor can register as a member" do
    visit register_path
    fill_in "full_name", with: "New Visitor"
    fill_in "email_address", with: "new.visitor@example.com"
    fill_in "password", with: "password123"
    fill_in "password_confirmation", with: "password123"
    click_button I18n.t("frontend.forms.create_account")

    expect(page).to have_text("New Visitor")
    expect(page).to have_text(I18n.t("frontend.profile.edit_title"))
  end
end
