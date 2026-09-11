require "rails_helper"

RSpec.describe UserImports::CsvParser, type: :service do
  def fixture_path(filename)
    Rails.root.join("spec/fixtures/files", filename).to_s
  end

  describe "#rows" do
    it "returns a hash for each non-blank row" do
      rows = described_class.new(fixture_path("users.csv")).rows

      expect(rows.size).to eq(3)
    end

    it "normalizes keys to lowercase strings" do
      rows = described_class.new(fixture_path("users.csv")).rows

      expect(rows.first.keys).to all(match(/\A[a-z_]+\z/))
    end

    it "maps columns correctly" do
      row = described_class.new(fixture_path("users.csv")).rows.first

      expect(row["full_name"]).to eq("Imported One")
      expect(row["email"]).to eq("imported.one@example.com")
      expect(row["role"]).to eq("member")
    end

    it "skips entirely blank rows" do
      csv_content = "full_name,email,role\nAlice,alice@ex.com,member\n,,\n"
      Tempfile.create([ "blank_rows", ".csv" ]) do |f|
        f.write(csv_content)
        f.flush

        rows = described_class.new(f.path).rows
        expect(rows.size).to eq(1)
      end
    end

    it "handles BOM-prefixed UTF-8 files" do
      csv_content = "\xEF\xBB\xBFfull_name,email,role\nBOM User,bom@ex.com,member\n"
      Tempfile.create([ "bom", ".csv" ]) do |f|
        f.binmode
        f.write(csv_content)
        f.flush

        rows = described_class.new(f.path).rows
        expect(rows.first["full_name"]).to eq("BOM User")
      end
    end
  end
end
