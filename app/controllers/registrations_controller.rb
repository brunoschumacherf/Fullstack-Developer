class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  def new
    render inertia: "Auth/Register"
  end

  def create
    user = User.new(user_params)
    user.role = :member

    if user.save
      start_new_session_for user
      redirect_to profile_path, notice: "Conta criada com sucesso!"
    else
      redirect_to register_path, alert: user.errors.full_messages.to_sentence
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :email_address, :password, :password_confirmation, :avatar)
  end
end