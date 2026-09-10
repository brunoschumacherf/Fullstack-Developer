module Admin
  class DashboardController < ApplicationController
    before_action :require_admin

    def index
      render inertia: "Admin/Dashboard", props: {
        stats: {
          total_users: User.count,
          role_counts: User.group(:role).count
        },
        users: User.all.map { |u|
          {
            id: u.id,
            full_name: u.full_name,
            email_address: u.email_address,
            role: u.role,
            avatar_url: u.avatar_url
          }
        }
      }
    end
  end
end