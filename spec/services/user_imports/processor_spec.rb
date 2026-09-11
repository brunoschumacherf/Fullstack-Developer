require "rails_helper"

RSpec.describe UserImports::Processor, type: :service do
  it "imports valid rows and records validation failures" do
    import = build_import("users.csv")

    expect do
      UserImports::Processor.call(import)
    end.to change(User, :count).by(2)

    import.reload
    expect(import.completed?).to be_truthy
    expect(import.total_rows).to eq(3)
    expect(import.successful_rows).to eq(2)
    expect(import.failed_rows).to eq(1)
    expect(User.exists?(email_address: "imported.one@example.com")).to be_truthy
    expect(User.exists?(email_address: "imported.admin@example.com")).to be_truthy
    expect(import.error_messages.any? { |message| message.include?("Linha 4") }).to be_truthy
  end

  it "marks the import as failed when the file cannot be parsed" do
    import = users(:admin).user_imports.new
    import.file.attach(
      io: StringIO.new("\xFF\xD8not-csv"),
      filename: "users.csv",
      content_type: "text/csv"
    )
    import.save!

    UserImports::Processor.call(import)

    expect(import.reload.failed?).to be_truthy
    expect(import.error_messages.present?).to be_truthy
  end

  private

  def build_import(filename)
    import = users(:admin).user_imports.new
    import.file.attach(
      io: file_fixture(filename).open,
      filename: filename,
      content_type: "text/csv"
    )
    import.save!
    import
  end
end
