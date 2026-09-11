class UserImportSerializer < ActiveModel::Serializer
  attributes :id, :status, :total, :processed, :successful, :failed, :percentage, :errors

  def total      = object.total_rows.to_i
  def processed  = object.processed_rows.to_i
  def successful = object.successful_rows.to_i
  def failed     = object.failed_rows.to_i
  def percentage = object.progress_percentage
  def errors     = Array(object.error_messages)
end
