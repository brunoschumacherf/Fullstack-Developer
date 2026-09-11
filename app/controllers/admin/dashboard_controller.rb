module Admin
  class DashboardController < BaseController
    def index
      render inertia: "Admin/Dashboard", props: {
        stats: Dashboard::Stats.call,
        users: User.order(:full_name).map { |u| UserSerializer.new(u).as_json },
        active_import: current_user.user_imports.where(status: %w[pending processing]).order(created_at: :desc).first&.then { |i| UserImportSerializer.new(i).as_json }
      }
    end
  end
end
