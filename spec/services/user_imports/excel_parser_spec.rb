require "rails_helper"

RSpec.describe UserImports::ExcelParser, type: :service do
  def fixture_path(filename)
    Rails.root.join("spec/fixtures/files", filename).to_s
  end

  describe "#rows" do
    it "returns a hash for each non-blank row" do
      rows = described_class.new(fixture_path("users.xlsx"), "xlsx").rows

      expect(rows.size).to eq(3)
    end

    it "normalizes keys from the header row to lowercase strings" do
      rows = described_class.new(fixture_path("users.xlsx"), "xlsx").rows

      expect(rows.first.keys).to all(match(/\A[a-z_]+\z/))
    end

    it "maps columns correctly" do
      row = described_class.new(fixture_path("users.xlsx"), "xlsx").rows.first

      expect(row["full_name"]).to eq("Imported One")
      expect(row["email"]).to eq("imported.one@example.com")
      expect(row["role"]).to eq("member")
    end

    it "skips entirely blank rows" do
      rows = described_class.new(fixture_path("users.xlsx"), "xlsx").rows

      expect(rows).to all(satisfy { |r| r.values.any? { |v| v.present? } })
    end

    it "raises an error for an unsupported extension passed to Roo" do
      expect do
        described_class.new(fixture_path("users.xlsx"), "pdf").rows
      end.to raise_error(StandardError)
    end
  end
end
