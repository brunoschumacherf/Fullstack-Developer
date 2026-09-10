class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar

  enum :role, { member: "member", admin: "admin" }, default: :member

  has_many :sessions, dependent: :destroy
  has_many :user_imports, dependent: :destroy

  validates :full_name, presence: true, length: { maximum: 100 }
  validates :email_address, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 8 }, if: -> { new_record? || changes[:password_digest] }

  after_commit :broadcast_dashboard_stats, on: %i[create destroy update]

  def avatar_url
    if avatar.attached?
      Rails.application.routes.url_helpers.rails_blob_url(avatar, only_path: true)
    else
      "https://ui-avatars.com/api/?name=#{CGI.escape(full_name)}&background=random"
    end
  end

  private

  def broadcast_dashboard_stats
    ActionCable.server.broadcast("admin_dashboard_channel", {
      total_users: User.count,
      role_counts: User.group(:role).count
    })
  end
end