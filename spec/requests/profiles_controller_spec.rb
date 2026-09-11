require "rails_helper"

RSpec.describe ProfilesController, type: :request do
  it "keeps the profile unchanged when validation fails" do
    expect do
      patch profile_path, params: { user: { full_name: "" } }
    end.not_to change { users(:member).reload.full_name }
    expect(response).to redirect_to(profile_path)
    expect(flash[:alert]).to be_present
  end

  it "updates the password when a matching confirmation is supplied" do
    patch profile_path, params: { user: { password: "newpassword123", password_confirmation: "newpassword123" } }
    expect(response).to redirect_to(profile_path)
    expect(users(:member).reload.authenticate("newpassword123")).to eq(users(:member))
    expect(users(:member).authenticate("password123")).to be_falsey
  end

  it "prevents the last admin from deleting their own account" do
    delete logout_path
    users(:second_admin).destroy!
    sign_in_as users(:admin)
    expect { delete profile_path }.not_to change(User, :count)
    expect(response).to redirect_to(profile_path)
    expect(flash[:alert]).to be_present
  end

  before do
    sign_in_as users(:member)
  end

  it "shows the signed-in user's profile" do
    get profile_path
    expect(response).to have_http_status(:success)
    expect(inertia.component).to eq("Profile/Show")
    expect(inertia.props.dig(:user, :id)).to eq(users(:member).id)
  end

  it "updates the signed-in user's profile" do
    patch profile_path, params: {
      user: {
        full_name: "Morgan Updated",
        email_address: users(:member).email_address
      }
    }

    expect(response).to redirect_to(profile_path)
    expect(users(:member).reload.full_name).to eq("Morgan Updated")
  end

  it "does not allow members to change their role" do
    expect do
      patch profile_path, params: {
        user: {
          full_name: users(:member).full_name,
          email_address: users(:member).email_address,
          role: "admin"
        }
      }
    end.not_to change { users(:member).reload.role }
    expect(response).to redirect_to(profile_path)
  end

  it "deletes the signed-in user's account" do
    expect do
      delete profile_path
    end.to change(User, :count).by(-1)

    expect(response).to redirect_to(register_path)
  end
end
