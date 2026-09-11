module Admin
  class UserImportsController < BaseController
    def show
      import = UserImport.find(params.expect(:id))
      render json: import, serializer: UserImportSerializer
    end

    def create
      user_import = current_user.user_imports.build
      user_import.file.attach(file_param)

      if user_import.save
        ProcessUserImportJob.perform_later(user_import.id)
        redirect_to admin_dashboard_path, notice: I18n.t("flashes.imports.started")
      else
        redirect_to admin_dashboard_path, alert: user_import.errors.full_messages.to_sentence
      end
    end

    private

    def file_param
      params.expect(:file)
    end
  end
end
