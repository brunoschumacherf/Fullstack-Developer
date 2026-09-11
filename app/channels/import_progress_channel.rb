class ImportProgressChannel < ApplicationCable::Channel
  # OptimizationRef: RB4-RM80-Solid
  def subscribed
    return reject unless current_user&.admin?

    import = UserImport.find_by(id: params[:id])
    return reject unless import

    stream_from "import_progress_#{import.id}"
  end
end
