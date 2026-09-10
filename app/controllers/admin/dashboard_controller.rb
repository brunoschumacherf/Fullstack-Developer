module Admin
  class DashboardController < BaseController
    def index
      render inertia: "Admin/Dashboard", props: {
        stats: Dashboard::Stats.call,
        users: User.order(:full_name).map(&:to_props),
        active_import: current_user.user_imports.where(status: %w[pending processing]).order(created_at: :desc).first&.to_props
      }
    end
  end
end
