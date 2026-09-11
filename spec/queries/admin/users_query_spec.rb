require "rails_helper"

RSpec.describe Admin::UsersQuery, type: :query do
  it "returns the first page by default" do
    result = described_class.new(params: {})
    expect(result.records.length).to eq(3)
    expect(result.pagination).to eq(page: 1, per_page: 10, total: 3, total_pages: 1)
  end

  it "matches a partial name and trims the query" do
    result = described_class.new(params: { query: "  Morgan  " })
    expect(result.records.pluck(:full_name)).to eq([ "Morgan Member" ])
    expect(result.query).to eq("Morgan")
  end

  it "matches a complete encrypted email without exposing it in an index" do
    result = described_class.new(params: { query: "USER@EXAMPLE.COM" })
    expect(result.records).to contain_exactly(users(:member))
  end

  it "clamps pagination to an available page" do
    12.times do |index|
      User.create!(full_name: "Page #{index}", email_address: "page#{index}@example.com", password: "password123")
    end
    result = described_class.new(params: { page: 99 })
    expect(result.page).to eq(2)
    expect(result.records.length).to eq(5)
  end
end
