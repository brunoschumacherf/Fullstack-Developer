require "rails_helper"

RSpec.describe UserImports::ParserFactory, type: :service do
  def fixture_path(filename)
    Rails.root.join("spec/fixtures/files", filename).to_s
  end

  describe ".parse" do
    it "delegates csv extension to CsvParser" do
      expect(UserImports::CsvParser).to receive(:new).with(fixture_path("users.csv")).and_call_original

      described_class.parse(fixture_path("users.csv"), "csv")
    end

    it "delegates xlsx extension to ExcelParser" do
      expect(UserImports::ExcelParser).to receive(:new).with(fixture_path("users.xlsx"), "xlsx").and_call_original

      described_class.parse(fixture_path("users.xlsx"), "xlsx")
    end

    it "delegates xls extension to ExcelParser" do
      parser_double = instance_double(UserImports::ExcelParser, rows: [])
      allow(UserImports::ExcelParser).to receive(:new).and_return(parser_double)

      described_class.parse("/any/path.xls", "xls")

      expect(UserImports::ExcelParser).to have_received(:new).with("/any/path.xls", "xls")
    end

    it "delegates ods extension to ExcelParser" do
      parser_double = instance_double(UserImports::ExcelParser, rows: [])
      allow(UserImports::ExcelParser).to receive(:new).and_return(parser_double)

      described_class.parse("/any/path.ods", "ods")

      expect(UserImports::ExcelParser).to have_received(:new).with("/any/path.ods", "ods")
    end

    it "raises ArgumentError for an unsupported extension" do
      expect do
        described_class.parse("/any/path.pdf", "pdf")
      end.to raise_error(ArgumentError, /não suportado/)
    end

    it "is case-insensitive for the extension" do
      expect(UserImports::CsvParser).to receive(:new).and_call_original

      described_class.parse(fixture_path("users.csv"), "CSV")
    end

    it "returns an array of hashes" do
      rows = described_class.parse(fixture_path("users.csv"), "csv")

      expect(rows).to be_an(Array)
      expect(rows).to all(be_a(Hash))
    end
  end
end
