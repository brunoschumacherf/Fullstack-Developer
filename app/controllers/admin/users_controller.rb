module Admin
  class UsersController < BaseController
    before_action :set_user, only: %i[edit update destroy]

    def index
      redirect_to admin_dashboard_path
    end

    def new
      render inertia: "Admin/Users/New"
    end

    def edit
      render inertia: "Admin/Users/Edit", props: { user: UserSerializer.new(@user).as_json }
    end

    def create
      user = User.new(user_params)

      if user.save
        redirect_to admin_dashboard_path, notice: I18n.t("flashes.users.created")
      else
        redirect_to new_admin_user_path, inertia: { errors: user.errors }, alert: user.errors.full_messages.to_sentence
      end
    end

    def update
      if @user.update(user_params)
        redirect_to admin_dashboard_path, notice: I18n.t("flashes.users.updated")
      else
        redirect_to edit_admin_user_path(@user), inertia: { errors: @user.errors },
          alert: @user.errors.full_messages.to_sentence
      end
    end

    def destroy
      if @user.destroy
        redirect_to admin_dashboard_path, notice: I18n.t("flashes.users.deleted")
      else
        redirect_to admin_dashboard_path, alert: @user.errors.full_messages.to_sentence
      end
    end

    private

    def set_user
      @user = User.find(params.expect(:id))
    end

    def user_params
      permitted = params.expect(user: [ :full_name, :email_address, :password, :password_confirmation, :role, :avatar, :avatar_url ])
      permitted.delete(:password) if permitted[:password].blank?
      permitted.delete(:password_confirmation) if permitted[:password_confirmation].blank?
      permitted
    end
  end
end
