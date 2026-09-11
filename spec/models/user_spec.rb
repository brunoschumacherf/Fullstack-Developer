require "rails_helper"

RSpec.describe User, type: :model do
  it "uses an attached image instead of the remote avatar" do
    user = users(:member)
    user.avatar.attach(io: StringIO.new("image"), filename: "avatar.png", content_type: "image/png", identify: false)
    expect(user).to be_valid
    expect(user.avatar_image_url).to eq(Rails.application.routes.url_helpers.rails_blob_path(user.avatar, only_path: true))
  end

  it "rejects attachments that are not images" do
    user = users(:member)
    user.avatar.attach(io: StringIO.new("notes"), filename: "notes.txt", content_type: "text/plain", identify: false)
    expect(user).not_to be_valid
    expect(user.errors.of_kind?(:avatar, :invalid_type)).to be(true)
  end

  it "rejects an avatar larger than five megabytes" do
    user = users(:member)
    user.avatar.attach(
      io: StringIO.new("a" * (5.megabytes + 1)), filename: "avatar.png", content_type: "image/png", identify: false
    )
    expect(user).not_to be_valid
    expect(user.errors.of_kind?(:avatar, :too_large)).to be(true)
  end

  before do
    @admin = users(:admin)
    @member = users(:member)
  end

  it "accepts a valid user" do
    user = User.new(
      full_name: "Casey New",
      email_address: "casey@example.com",
      password: "password123",
      password_confirmation: "password123",
      role: :member
    )

    expect(user.valid?).to be_truthy
  end

  it "requires full name, email, and password" do
    user = User.new
    expect(user.valid?).to be_falsey
    expect(user.errors[:full_name]).to include(I18n.t("errors.messages.blank"))
    expect(user.errors[:email_address]).to include(I18n.t("errors.messages.blank"))
    expect(user.errors[:password]).to include(I18n.t("errors.messages.blank"))
  end

  it "rejects invalid emails" do
    user = User.new(full_name: "Casey", email_address: "not-an-email", password: "password123")
    expect(user.valid?).to be_falsey
    expect(user.errors[:email_address].present?).to be_truthy
  end

  it "enforces unique emails" do
    user = User.new(
      full_name: "Copy",
      email_address: @member.email_address,
      password: "password123"
    )

    expect(user.valid?).to be_falsey
    expect(user.errors[:email_address]).to include(I18n.t("errors.messages.taken"))
  end

  it "defaults new users to member" do
    user = User.create!(
      full_name: "Default Role",
      email_address: "default.role@example.com",
      password: "password123"
    )

    expect(user.member?).to be_truthy
  end

  it "rejects invalid avatar urls" do
    @member.avatar_url = "ftp://example.com/avatar.png"
    expect(@member.valid?).to be_falsey
  end

  it "prevents demoting the last remaining admin" do
    users(:second_admin).destroy!
    @admin.role = :member

    expect(@admin.valid?).to be_falsey
    expect(@admin.errors[:role]).to include(I18n.t("activerecord.errors.models.user.attributes.role.last_admin"))
  end

  it "prevents deleting the last remaining admin" do
    users(:second_admin).destroy!

    expect do
      @admin.destroy
    end.not_to change(User, :count)
    expect(@admin.errors[:base]).to include(I18n.t("activerecord.errors.models.user.attributes.base.last_admin"))
  end

  it "serializes props with an avatar fallback" do
    user = User.create!(
      full_name: "No Avatar",
      email_address: "no.avatar@example.com",
      password: "password123",
      avatar_url: nil
    )

    expect(user.to_props[:id]).to eq(user.id)
    expect(user.avatar_image_url).to include("ui-avatars.com")
  end

  it "encrypts email addresses at rest" do
    raw = User.connection.select_value(
      User.sanitize_sql_array([ "SELECT email_address FROM users WHERE id = ?", @member.id ])
    )

    expect(raw).not_to eq(@member.email_address)
  end
end
