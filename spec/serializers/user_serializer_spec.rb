require "rails_helper"

RSpec.describe UserSerializer, type: :serializer do
  subject(:serialized) { described_class.new(user).as_json }

  let(:user) { users(:admin) }

  it "exposes the expected keys" do
    expect(serialized.keys).to contain_exactly(:id, :full_name, :email_address, :role, :avatar_url)
  end

  it "serializes basic attributes correctly" do
    expect(serialized[:id]).to eq(user.id)
    expect(serialized[:full_name]).to eq(user.full_name)
    expect(serialized[:email_address]).to eq(user.email_address)
    expect(serialized[:role]).to eq(user.role)
  end

  context "when the user has an avatar_url set" do
    before { user.update!(avatar_url: "https://example.com/avatar.png") }

    it "returns the avatar_url" do
      expect(serialized[:avatar_url]).to eq("https://example.com/avatar.png")
    end
  end

  context "when the user has no avatar" do
    before { user.update!(avatar_url: nil) }

    it "falls back to the ui-avatars URL" do
      expect(serialized[:avatar_url]).to include("ui-avatars.com")
    end
  end
end
