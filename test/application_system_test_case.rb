require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]

  def sign_in(email, password = "password123")
    visit login_path
    fill_in "email_address", with: email
    fill_in "password", with: password
    click_button I18n.t("frontend.login.submit")
  end
end
