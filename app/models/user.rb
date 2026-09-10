class User < ApplicationRecord
  EMAIL_FORMAT = URI::MailTo::EMAIL_REGEXP
  REMOTE_URL_FORMAT = /\Ahttps?:\/\/.+\z/i

  has_secure_password
  has_one_attached :avatar

  enum :role, { member: "member", admin: "admin" }, default: :member, validate: true

  has_many :sessions, dependent: :destroy
  has_many :user_imports, dependent: :destroy

  encrypts :email_address, deterministic: true, downcase: true

  normalizes :email_address, with: ->(email) { email.strip.downcase }
  normalizes :full_name, with: ->(name) { name.strip }
  normalizes :avatar_url, with: ->(url) { url.presence&.strip }

  validates :full_name, presence: true, length: { maximum: 100 }
  validates :email_address, presence: true, uniqueness: true, format: { with: EMAIL_FORMAT }
  validates :password, length: { minimum: 8 }, allow_nil: true
  validates :avatar_url, format: { with: REMOTE_URL_FORMAT, allow_blank: true }
  validate :acceptable_avatar
  validate :must_keep_one_admin, on: :update

  before_destroy :prevent_destroying_last_admin

  after_commit :broadcast_dashboard_stats, on: %i[create update destroy]

  def self.dashboard_stats
    Dashboard::Stats.call
  end

  def avatar_image_url
    if avatar.attached?
      Rails.application.routes.url_helpers.rails_blob_path(avatar, only_path: true)
    elsif avatar_url.present?
      avatar_url
    else
      "https://ui-avatars.com/api/?name=#{CGI.escape(full_name.to_s)}&background=4f46e5&color=fff"
    end
  end

  def to_props
    {
      id: id,
      full_name: full_name,
      email_address: email_address,
      role: role,
      avatar_url: avatar_image_url
    }
  end

  private

  def acceptable_avatar
    return unless avatar.attached?

    unless avatar.content_type.in?(%w[image/png image/jpeg image/jpg image/gif image/webp])
      errors.add(:avatar, :invalid_type)
    end

    errors.add(:avatar, :too_large) if avatar.byte_size > 5.megabytes
  end

  def must_keep_one_admin
    return unless role_changed? && role_was == "admin" && member? && last_admin?

    errors.add(:role, :last_admin)
  end

  def prevent_destroying_last_admin
    return unless admin? && last_admin?

    errors.add(:base, :last_admin)
    throw :abort
  end

  def last_admin?
    User.admin.where.not(id: id).none?
  end

  def broadcast_dashboard_stats
    Dashboard::Broadcaster.stats
  end
end
