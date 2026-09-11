require "rails_helper"

RSpec.describe UserImportSerializer, type: :serializer do
  subject(:serialized) { described_class.new(import).as_json }

  let(:import) do
    record = users(:admin).user_imports.new(
      status:          "completed",
      total_rows:      10,
      processed_rows:  10,
      successful_rows: 8,
      failed_rows:     2,
      error_messages:  [ "Linha 3: e-mail inválido" ]
    )
    record.file.attach(
      io:           file_fixture("users.csv").open,
      filename:     "users.csv",
      content_type: "text/csv"
    )
    record.save!
    record
  end

  it "exposes the expected keys" do
    expect(serialized.keys).to contain_exactly(
      :id, :status, :total, :processed, :successful, :failed, :percentage, :errors
    )
  end

  it "maps column aliases correctly" do
    expect(serialized[:total]).to eq(10)
    expect(serialized[:processed]).to eq(10)
    expect(serialized[:successful]).to eq(8)
    expect(serialized[:failed]).to eq(2)
  end

  it "calculates percentage" do
    expect(serialized[:percentage]).to eq(100)
  end

  it "wraps error_messages in an array" do
    expect(serialized[:errors]).to eq([ "Linha 3: e-mail inválido" ])
  end

  it "returns an empty array when there are no errors" do
    import.update!(error_messages: nil)
    expect(described_class.new(import).as_json[:errors]).to eq([])
  end

  it "returns 0 percentage when total_rows is zero" do
    import.update!(total_rows: 0, processed_rows: 0)
    expect(described_class.new(import).as_json[:percentage]).to eq(0)
  end
end
