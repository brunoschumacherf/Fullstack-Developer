require "rails_helper"

RSpec.describe RegistrationsController, type: :request do
  it "redirects an authenticated admin away from registration" do
    sign_in_as users(:admin)
    get register_path
    expect(response).to redirect_to(admin_dashboard_path)
  end

  it "renders registration for visitors" do
    get register_path
    expect(response).to have_http_status(:success)
    expect(inertia.component).to eq("Auth/Register")
  end

  it "creates a member account and signs the visitor in" do
    expect do
      post register_path, params: {
        user: {
          full_name: "Visitor Person",
          email_address: "visitor@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end.to change(User, :count).by(1)

    user = User.find_by(email_address: "visitor@example.com")
    expect(user.member?).to be_truthy
    expect(response).to redirect_to(profile_path)
  end

  it "does not allow visitors to register as admin" do
    expect do
      post register_path, params: {
        user: {
          full_name: "Evil Visitor",
          email_address: "evil@example.com",
          password: "password123",
          password_confirmation: "password123",
          role: "admin"
        }
      }
    end.to change(User, :count).by(1)
    expect(User.find_by!(email_address: "evil@example.com")).to be_member
    expect(response).to redirect_to(profile_path)
  end

  it "returns validation errors for duplicate emails" do
    post register_path, params: {
      user: {
        full_name: "Dup",
        email_address: users(:member).email_address,
        password: "password123",
        password_confirmation: "password123"
      }
    }

    expect(response).to redirect_to(register_path)
  end
end
