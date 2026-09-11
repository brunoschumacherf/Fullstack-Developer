require "rails_helper"

RSpec.describe SessionsController, type: :request do
  it "redirects an authenticated user away from login" do
    sign_in_as users(:member)
    get login_path
    expect(response).to redirect_to(profile_path)
  end

  it "renders the login page for visitors" do
    get login_path
    expect(response).to have_http_status(:success)
    expect(inertia.component).to eq("Auth/Login")
  end

  it "redirects admins to the dashboard after login" do
    post login_path, params: { email_address: users(:admin).email_address, password: "password123" }

    expect(response).to redirect_to(admin_dashboard_path)
  end

  it "redirects members to their profile after login" do
    post login_path, params: { email_address: users(:member).email_address, password: "password123" }

    expect(response).to redirect_to(profile_path)
  end

  it "rejects invalid credentials" do
    post login_path, params: { email_address: users(:admin).email_address, password: "wrong-password" }

    expect(response).to redirect_to(login_path)
    follow_redirect!
    expect(flash[:alert]).to eq(I18n.t("flashes.sessions.invalid"))
  end

  it "signs the user out" do
    sign_in_as users(:member)
    delete logout_path

    expect(response).to redirect_to(login_path)
    get profile_path
    expect(response).to redirect_to(login_path)
  end
end
