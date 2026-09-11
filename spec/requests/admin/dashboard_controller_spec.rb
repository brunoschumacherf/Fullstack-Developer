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
    expect(inertia.props[:users].length).to be <= 10
    expect(inertia.props[:user_pagination]).to include(page: 1, per_page: 10, total_pages: 1)
  end

  it "searches users by partial name" do
    sign_in_as users(:admin)
    get admin_dashboard_path, params: { query: "Morgan" }

    expect(response).to have_http_status(:success)
    expect(inertia.props[:users].pluck(:full_name)).to eq([ "Morgan Member" ])
    expect(inertia.props[:user_filters]).to eq("query" => "Morgan")
    expect(inertia.props[:user_pagination][:total]).to eq(1)
  end

  it "searches users by their full encrypted email" do
    sign_in_as users(:admin)
    get admin_dashboard_path, params: { query: "USER@EXAMPLE.COM" }

    expect(inertia.props[:users].pluck(:email_address)).to eq([ "user@example.com" ])
  end

  it "paginates users and clamps pages outside the available range" do
    12.times do |index|
      User.create!(full_name: "Pagination #{index}", email_address: "pagination#{index}@example.com", password: "password123")
    end
    sign_in_as users(:admin)
    get admin_dashboard_path, params: { page: 99 }

    expect(inertia.props[:user_pagination]).to include(page: 2, total: 15, total_pages: 2)
    expect(inertia.props[:users].length).to eq(5)
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
