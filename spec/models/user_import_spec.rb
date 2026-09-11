require "rails_helper"

RSpec.describe UserImport, type: :model do
  it "rejects spreadsheets larger than ten megabytes" do
    import = users(:admin).user_imports.new
    import.file.attach(
      io: StringIO.new("a" * (10.megabytes + 1)), filename: "users.csv", content_type: "text/csv"
    )
    expect(import).not_to be_valid
    expect(import.errors.of_kind?(:file, :too_large)).to be(true)
  end

  it "requires a spreadsheet file" do
    import = users(:admin).user_imports.new
    expect(import.valid?).to be_falsey
    expect(import.errors[:file]).to include(I18n.t("errors.messages.blank"))
  end

  it "rejects unsupported file types" do
    import = users(:admin).user_imports.new
    import.file.attach(
      io: StringIO.new("not a spreadsheet"),
      filename: "notes.txt",
      content_type: "text/plain"
    )

    expect(import.valid?).to be_falsey
    expect(import.errors[:file]).to include(I18n.t("activerecord.errors.models.user_import.attributes.file.invalid_type"))
  end

  it "computes progress percentage" do
    import = users(:admin).user_imports.new(total_rows: 4, processed_rows: 1)
    expect(import.progress_percentage).to eq(25)
  end

  it "returns zero progress when there are no rows" do
    import = users(:admin).user_imports.new(total_rows: 0, processed_rows: 0)
    expect(import.progress_percentage).to eq(0)
  end
end
