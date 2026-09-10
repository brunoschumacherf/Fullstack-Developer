class ProfilesController < ApplicationController
  def show
    render inertia: "Profile/Show", props: {
      user: {
        id: current_user.id,
        full_name: current_user.full_name,
        email_address: current_user.email_address,
        role: current_user.role,
        avatar_url: current_user.avatar_url
      }
    }
  end

  def update
    if current_user.update(profile_params)
      redirect_to profile_path, notice: "Perfil atualizado com sucesso!"
    else
      redirect_to profile_path, alert: current_user.errors.full_messages.to_sentence
    end
  end

  def destroy
    current_user.destroy
    terminate_session
    redirect_to register_path, notice: "Sua conta foi excluída permanentemente."
  end

  private

  def profile_params
    params.require(:user).permit(:full_name, :email_address, :password, :password_confirmation, :avatar)
  end
end