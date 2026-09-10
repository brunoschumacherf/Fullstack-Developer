class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  def new
    render inertia: "Auth/Login"
  end

  def create
    if user = User.authenticate_by(email_address: params[:email_address], password: params[:password])
      start_new_session_for user
      redirect_after_login(user)
    else
      redirect_to login_path, alert: "E-mail ou senha inválidos."
    end
  end

  def destroy
    terminate_session
    redirect_to login_path, notice: "Sessão encerrada com sucesso."
  end

  private

  def redirect_after_login(user)
    if user.admin?
      redirect_to admin_dashboard_path
    else
      redirect_to profile_path
    end
  end
end