class ApplicationController < ActionController::Base
  include Authentication

  allow_browser versions: :modern

  inertia_share do
    {
      auth: {
        user: current_user && UserSerializer.new(current_user).as_json
      },
      flash: {
        notice: flash[:notice],
        alert: flash[:alert]
      },
      i18n: I18n.t("frontend")
    }
  end

  private

  def require_admin
    return if current_user&.admin?

    redirect_to profile_path, alert: I18n.t("flashes.auth.admin_required")
  end
end
