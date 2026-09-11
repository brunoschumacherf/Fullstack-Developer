require "rails_helper"

RSpec.describe ImportProgressChannel, type: :channel do
  it "rejects connections without a user" do
    stub_connection current_user: nil
    subscribe id: @import.id
    expect(subscription).to be_rejected
    expect(subscription.streams).to be_empty
  end

  before do
    @import = users(:admin).user_imports.new
    @import.file.attach(
      io: file_fixture("users.csv").open,
      filename: "users.csv",
      content_type: "text/csv"
    )
    @import.save!
  end

  it "admins can subscribe to an import stream" do
    stub_connection current_user: users(:admin)
    subscribe id: @import.id

    expect(subscription.confirmed?).to be_truthy
    expect(subscription).to have_stream_from("import_progress_#{@import.id}")
  end

  it "members are rejected" do
    stub_connection current_user: users(:member)
    subscribe id: @import.id
    expect(subscription.rejected?).to be_truthy
    expect(subscription.streams).to be_empty
  end

  it "unknown imports are rejected" do
    stub_connection current_user: users(:admin)
    subscribe id: 0
    expect(subscription.rejected?).to be_truthy
    expect(subscription.streams).to be_empty
  end
end
