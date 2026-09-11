require "rails_helper"

RSpec.describe DashboardChannel, type: :channel do
  it "rejects connections without a user" do
    stub_connection current_user: nil
    subscribe
    expect(subscription).to be_rejected
    expect(subscription.streams).to be_empty
  end

  it "admins can subscribe" do
    stub_connection current_user: users(:admin)
    subscribe
    expect(subscription.confirmed?).to be_truthy
    expect(subscription).to have_stream_from(Dashboard::Broadcaster::STATS_STREAM)
  end

  it "members are rejected" do
    stub_connection current_user: users(:member)
    subscribe
    expect(subscription.rejected?).to be_truthy
  end
end
