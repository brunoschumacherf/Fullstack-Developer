module Admin
  class UsersController < ApplicationController
    before_action :require_admin

    def update
      user = User.find(params[:id])
      if user.update(user_params)
        redirect_to admin_dashboard_path, notice: "Usuário atualizado."
      else
        redirect_to admin_dashboard_path, alert: user.errors.full_messages.to_sentence
      end
    end

    def destroy
      user = User.find(params[:id])
      user.destroy
      redirect_to admin_dashboard_path, notice: "Usuário removido."
    end

    private

    def user_params
      params.require(:user).permit(:full_name, :email_address, :role)
    end
  end
end