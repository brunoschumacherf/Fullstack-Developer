class ApplicationController < ActionController::Base
  include Authentication

  inertia_share do
    {
      auth: {
        user: current_user ? {
          id: current_user.id,
          full_name: current_user.full_name,
          email_address: current_user.email_address,
          role: current_user.role,
          avatar_url: current_user.avatar_url
        } : nil
      }
    }
  end

  private

  def require_admin
    unless current_user&.admin?
      redirect_to profile_path, alert: "Acesso restrito para administradores."
    end
  end
end