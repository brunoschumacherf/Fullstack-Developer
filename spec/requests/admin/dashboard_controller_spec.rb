require "rails_helper"

RSpec.describe Admin::DashboardController, type: :request do
  it "includes the admin's active import" do
    import = users(:admin).user_imports.new
    import.file.attach(io: file_fixture("users.csv").open, filename: "users.csv", content_type: "text/csv")
    import.save!
    sign_in_as users(:admin)
    get admin_dashboard_path
    expect(response).to have_http_status(:success)
    expect(inertia.props[:active_import]).to include(id: import.id, status: "pending")
  end

  it "admins can open the dashboard" do
    sign_in_as users(:admin)
    get admin_dashboard_path

    expect(response).to have_http_status(:success)
    expect(inertia.component).to eq("Admin/Dashboard")
    expect(inertia.props[:stats][:total_users] >= 3).to be_truthy
    expect(inertia.props[:users].is_a?(Array)).to be_truthy
  end

  it "members are blocked from the dashboard" do
    sign_in_as users(:member)
    get admin_dashboard_path

    expect(response).to redirect_to(profile_path)
  end

  it "visitors are sent to login" do
    get admin_dashboard_path
    expect(response).to redirect_to(login_path)
  end
end
