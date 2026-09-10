module Admin
  class UserImportsController < ApplicationController
    before_action :require_admin

    def create
      user_import = current_user.user_imports.build
      user_import.file.attach(params[:file])

      if user_import.save
        ProcessUserImportJob.perform_later(user_import.id)
        redirect_to admin_dashboard_path, notice: "Importação iniciada com sucesso!"
      else
        redirect_to admin_dashboard_path, alert: "Erro ao anexar arquivo de planilha."
      end
    end
  end
end