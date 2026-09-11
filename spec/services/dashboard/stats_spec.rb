require "rails_helper"

RSpec.describe Dashboard::Stats, type: :service do
  it "counts users by role" do
    stats = Dashboard::Stats.call

    expect(stats[:total_users]).to eq(User.count)
    expect(stats[:role_counts]["admin"]).to eq(User.admin.count)
    expect(stats[:role_counts]["member"]).to eq(User.member.count)
  end
end
