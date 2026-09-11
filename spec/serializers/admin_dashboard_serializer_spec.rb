require "rails_helper"

RSpec.describe AdminDashboardSerializer, type: :serializer do
  it "assembles dashboard props and serializes an active import" do
    import = users(:admin).user_imports.new
    import.file.attach(io: file_fixture("users.csv").open, filename: "users.csv", content_type: "text/csv")
    import.save!

    result = described_class.new(current_user: users(:admin), params: {}).as_json

    expect(result.keys).to contain_exactly(:stats, :users, :user_filters, :user_pagination, :active_import)
    expect(result[:active_import][:id]).to eq(import.id)
  end
end
