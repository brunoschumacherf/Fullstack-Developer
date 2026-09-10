class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  def new
    return redirect_to after_authentication_url if authenticated?

    render inertia: "Auth/Register"
  end

  def create
    user = User.new(registration_params)
    user.role = :member

    if user.save
      start_new_session_for user
      redirect_to profile_path, notice: I18n.t("flashes.registrations.created")
    else
      redirect_to register_path, inertia: { errors: user.errors }, alert: user.errors.full_messages.to_sentence
    end
  end

  private

  def registration_params
    params.expect(user: [ :full_name, :email_address, :password, :password_confirmation, :avatar, :avatar_url ])
  end
end
