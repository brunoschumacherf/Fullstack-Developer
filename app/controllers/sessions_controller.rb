class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> {
    redirect_to login_path, alert: I18n.t("flashes.sessions.throttled")
  }

  def new
    return redirect_to after_authentication_url if authenticated?

    render inertia: "Auth/Login"
  end

  def create
    if (user = User.authenticate_by(email_address: params.expect(:email_address), password: params.expect(:password)))
      start_new_session_for user
      redirect_to after_authentication_url, notice: I18n.t("flashes.sessions.created")
    else
      redirect_to login_path, alert: I18n.t("flashes.sessions.invalid")
    end
  end

  def destroy
    terminate_session
    redirect_to login_path, notice: I18n.t("flashes.sessions.destroyed")
  end
end
