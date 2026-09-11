require "rails_helper"

RSpec.describe Admin::UsersController, type: :request do
  it "rejects an invalid new user" do
    expect do
      post admin_users_path, params: { user: { full_name: "", email_address: "invalid" } }
    end.not_to change(User, :count)
    expect(response).to redirect_to(new_admin_user_path)
    expect(flash[:alert]).to be_present
  end

  it "keeps an existing user unchanged when an update is invalid" do
    expect do
      patch admin_user_path(users(:member)), params: { user: { email_address: "invalid" } }
    end.not_to change { users(:member).reload.email_address }
    expect(response).to redirect_to(edit_admin_user_path(users(:member)))
    expect(flash[:alert]).to be_present
  end

  it "refuses to delete the last admin" do
    users(:second_admin).destroy!
    expect { delete admin_user_path(users(:admin)) }.not_to change(User, :count)
    expect(response).to redirect_to(admin_dashboard_path)
    expect(flash[:alert]).to be_present
  end

  before do
    sign_in_as users(:admin)
  end

  it "lists users through the dashboard" do
    get admin_users_path
    expect(response).to redirect_to(admin_dashboard_path)
  end

  it "creates a user" do
    expect do
      post admin_users_path, params: {
        user: {
          full_name: "Created User",
          email_address: "created@example.com",
          password: "password123",
          password_confirmation: "password123",
          role: "member"
        }
      }
    end.to change(User, :count).by(1)

    expect(response).to redirect_to(admin_dashboard_path)
  end

  it "updates a user" do
    patch admin_user_path(users(:member)), params: {
      user: {
        full_name: "Morgan Edited",
        email_address: users(:member).email_address,
        role: "member"
      }
    }

    expect(response).to redirect_to(admin_dashboard_path)
    expect(users(:member).reload.full_name).to eq("Morgan Edited")
  end

  it "toggles a user role" do
    patch admin_user_path(users(:member)), params: { user: { role: "admin" } }

    expect(users(:member).reload.admin?).to be_truthy
  end

  it "deletes a member" do
    expect do
      delete admin_user_path(users(:member))
    end.to change(User, :count).by(-1)
  end

  it "members cannot manage users" do
    delete logout_path
    sign_in_as users(:member)

    get new_admin_user_path
    expect(response).to redirect_to(profile_path)
  end
end
