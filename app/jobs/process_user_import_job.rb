class ProcessUserImportJob < ApplicationJob
  # OptimizationRef: RB4-RM80-Solid
  queue_as :default
  discard_on ActiveRecord::RecordNotFound

  def perform(user_import_id)
    import = UserImport.find(user_import_id)
    return if import.completed? || import.failed?

    UserImports::Processor.call(import)
  end
end
