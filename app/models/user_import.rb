class UserImport < ApplicationRecord
  belongs_to :user
  has_one_attached :file

  enum :status, { pending: "pending", processing: "processing", completed: "completed", failed: "failed" }, default: :pending

  validates :file, presence: true
  validate :acceptable_spreadsheet

  after_commit :broadcast_progress, on: %i[create update]

  def progress_percentage
    return 0 if total_rows.to_i.zero?

    ((processed_rows.to_f / total_rows) * 100).round
  end

  def to_props
    {
      id: id,
      status: status,
      total: total_rows.to_i,
      processed: processed_rows.to_i,
      successful: successful_rows.to_i,
      failed: failed_rows.to_i,
      percentage: progress_percentage,
      errors: Array(error_messages)
    }
  end

  private

  def acceptable_spreadsheet
    return unless file.attached?

    extension = File.extname(file.filename.to_s).downcase
    unless extension.in?(%w[.csv .xlsx])
      errors.add(:file, :invalid_type)
    end

    errors.add(:file, :too_large) if file.byte_size > 10.megabytes
  end

  def broadcast_progress
    Dashboard::Broadcaster.import_progress(self)
  end
end
