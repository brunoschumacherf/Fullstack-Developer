class ProfilesController < ApplicationController
  def show
    render inertia: "Profile/Show", props: { user: current_user.to_props }
  end

  def update
    if current_user.update(profile_params)
      redirect_to profile_path, notice: I18n.t("flashes.profiles.updated")
    else
      redirect_to profile_path, inertia: { errors: current_user.errors }, alert: current_user.errors.full_messages.to_sentence
    end
  end

  def destroy
    if current_user.destroy
      terminate_session
      redirect_to register_path, notice: I18n.t("flashes.profiles.deleted")
    else
      redirect_to profile_path, alert: current_user.errors.full_messages.to_sentence
    end
  end

  private

  def profile_params
    permitted = params.expect(user: [ :full_name, :email_address, :password, :password_confirmation, :avatar, :avatar_url ])
    permitted.delete(:password) if permitted[:password].blank?
    permitted.delete(:password_confirmation) if permitted[:password_confirmation].blank?
    permitted
  end
end
