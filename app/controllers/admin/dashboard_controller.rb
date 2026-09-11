module Admin
  class DashboardController < BaseController
    def index
      props = AdminDashboardSerializer.new(current_user: current_user, params: params).as_json
      render inertia: "Admin/Dashboard", props: props
    end
  end
end
